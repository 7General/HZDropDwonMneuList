//
//  DropDownMenuList.m
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#define CurrentWindow [self getCurrentWindowView]

#import "DropDownMenuList.h"

@implementation HZIndexPath

-(instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    if (self == [super init]) {
        self.column = column;
        self.row = row;
    }
    return self;
}

+(instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row {
    return [[self alloc] initWithColumn:column row:row];
}



@end



@interface DropDownMenuList ()

@property (nonatomic, assign) NSInteger  BtnTag;

@property (nonatomic,assign,getter=isSelected) BOOL btnSelected;
// 标题按钮
@property (nonatomic, strong) UIButton * titleButton;

@property (nonatomic, strong) UIView * DropDownMenuView;

@property (nonatomic, weak) UIButton *cover;

// 当前选中的Tag
@property (nonatomic, assign) NSInteger  currrntSelectedColumn;

@property (nonatomic, strong) UITableView * leftTableView;


// 标题高度
@property (nonatomic, assign) NSInteger  titleMenuHeight;

// 标题数组
@property (nonatomic, strong) NSMutableArray * titleMenuArry;

// 当前选中的列
@property (nonatomic, strong) NSMutableArray * currentSelectedRows;


@property (nonatomic, strong) NSMutableArray * titles;

//########################################
/** 用来显示具体内容的容器 */

@property (nonatomic) CGPoint sorcePoint;
@property (nonatomic) CGSize  viewSize;

@end

@implementation DropDownMenuList


-(instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, DDMWIDTH, height)];
    if (self) {
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, 0, DDMWIDTH, 0) style:UITableViewStylePlain];
        self.leftTableView.delegate = self;
        self.leftTableView.dataSource = self;
        self.leftTableView.rowHeight = 44;
        [self.DropDownMenuView addSubview:self.leftTableView];
        
        
        self.titleMenuHeight = height;
    }

    return self;
}


-(UIView *)DropDownMenuView {
    if (_DropDownMenuView == nil) {
        _DropDownMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 0)];
    }
    return _DropDownMenuView;
}

-(NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray new];
    }
    return _titles;
}

//##################################
+(instancetype)show:(CGPoint)orgin andHeight:(CGFloat)height {
    return [[self alloc] initWithOrgin:orgin andHeight:height];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)setDataSource:(id<DropDownMenuListDataSouce>)dataSource {
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(menuNumberOfRowInColumn)]) {
        self.titleMenuArry = [_dataSource menuNumberOfRowInColumn];
    }
    
    self.currentSelectedRows = [[NSMutableArray alloc] initWithCapacity:self.titleMenuArry.count];
    
    CGFloat  titleBtnWidth = DDMWIDTH / self.titleMenuArry.count;
    
    for (NSInteger index = 0; index < self.titleMenuArry.count; index++) {
        [self.currentSelectedRows addObject:@(0)];
        
        HZIndexPath * path = [HZIndexPath indexPathWithColumn:index row:0];
        NSString * titleString = [_dataSource menu:self titleForRowAtIndexPath:path];
        [self.titles addObject:titleString];
        
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleButton setImage:[UIImage imageNamed:@"rightImage_state"] forState:UIControlStateNormal];
        [self.titleButton setTitle:self.titleMenuArry[index] forState:UIControlStateNormal];
        [self.titleButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.titleButton setTitleColor:DDMColor(18, 108, 255) forState:UIControlStateNormal];
        [self.titleButton setTag:index + 1100];
        self.titleButton.frame = CGRectMake(index * titleBtnWidth, 0, titleBtnWidth, self.titleMenuHeight);
        [self addSubview:self.titleButton];
        [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置左右排列
        [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.titleButton.imageView.bounds.size.width + 4), 0, self.titleButton.imageView.bounds.size.width + 4)];
        [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleButton.titleLabel.bounds.size.width, 0, -self.titleButton.titleLabel.bounds.size.width)];


        if (index > 0) {
            UIImageView *line = [[UIImageView alloc] init];
            line.frame = CGRectMake(titleBtnWidth * index, 10, 0.5, 21);
            line.backgroundColor = DDMColor(220, 220, 220);
            [self addSubview:line];
        }
    }
    UIView * BottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleButton.frame), DDMWIDTH, 1)];
    BottomLine.backgroundColor = DDMColor(224, 224, 224);
    [self addSubview:BottomLine];
}

-(void)titleButtonClick:(UIButton *)sender {
    self.currrntSelectedColumn = sender.tag;
    
    if (self.btnSelected == NO) {
        sender.selected = NO;
    }
    sender.selected = !sender.selected;
    [self removeMenu];

   if (sender.tag != self.BtnTag || sender.selected) {
        sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [self setupCover];
        self.DropDownMenuView.backgroundColor = DDMColor(255, 255, 255);
        [UIView animateWithDuration:(0.25) animations:^{
            CGRect frame = CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 300);
            self.DropDownMenuView.frame = frame;
            [CurrentWindow addSubview:self.DropDownMenuView];
            self.leftTableView.frame = CGRectMake(0, 0, DDMWIDTH  , 300);
        }];
       
       
        self.btnSelected = YES;
        
        // 回归其他角标
        for (UIView * view in self.subviews) {
            if (view.tag > 1000 && view.tag != sender.tag) {
                ((UIButton *)view).imageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
    }
    else {
        self.btnSelected = NO;
        if (sender.tag == 1100) {
            sender.imageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
    
    // 代理点击事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectTitleAtColumn:)]) {
        [self.delegate menu:self didSelectTitleAtColumn:sender.tag];
    }
    [self.leftTableView reloadData];
    
    self.BtnTag = sender.tag;
}
-(void)initView {
    self.btnSelected = YES;
    self.BtnTag = -1;
    self.currrntSelectedColumn = 1100;
}


/**
 *  添加遮盖
 */
- (void)setupCover
{
        // 添加一个遮盖按钮
        UIButton *cover = [[UIButton alloc] init];
        CGFloat coverY = self.frame.size.height + self.frame.origin.y;
        cover.frame = CGRectMake(0, coverY, DDMWIDTH, DDMHEIGHT);

        [UIView animateWithDuration:0.1 animations:^{
            cover.backgroundColor = [DDMColor(0, 0, 0) colorWithAlphaComponent:0.5];
        }];
    
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        [CurrentWindow addSubview:cover];
        self.cover = cover;
}


/**
 *  消失
 */
-(void)dismiss {
    [self coverClick];
}


/**
 *  点击了底部的遮盖，遮盖消失
 */
- (void)coverClick
{
    self.btnSelected = NO;
    [self removeMenu];
}

/**
 *  菜单消失
 */
- (void)removeMenu
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 0);
        self.DropDownMenuView.frame = frame;
        
        self.leftTableView.frame = CGRectMake(0, 0, DDMWIDTH, 0);
        
        self.cover.alpha = 0;
        [self resetImageViewTransform];
        [self.cover removeFromSuperview];
    }];
}

/**
 *  回归角标
 */
-(void)resetImageViewTransform {
    for (UIView * view in self.subviews) {
        if (view.tag > 1000) {
            ((UIButton *)view).imageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
}


- (UIWindow *)getCurrentWindowView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    return window;
}



#pragma mark -TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColum:)]) {
        return [self.dataSource menu:self numberOfRowsInColum:self.currrntSelectedColumn - 1100];
    }else {
        return 5;
    }
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.textColor = DDMColor(9, 177, 247);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    HZIndexPath * path = [HZIndexPath indexPathWithColumn:self.currrntSelectedColumn - 1100 row:indexPath.row];
    // 文字
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:path];
    }
    // 图片
//    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:imageNameForRowAtIndexPath:)]) {
//        NSString * imageName = [self.dataSource menu:self imageNameForRowAtIndexPath:path];
//        cell.imageView.image = [UIImage imageNamed:imageName];
//    }
    NSInteger currentIndex = (self.currrntSelectedColumn - 1100);
    NSInteger  titleSelectRow = [self.currentSelectedRows[currentIndex] integerValue];
    if (indexPath.row == titleSelectRow) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:titleSelectRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setMenuWithSelectedRow:indexPath.row];
    HZIndexPath * path = [HZIndexPath indexPathWithColumn:self.currrntSelectedColumn - 1100 row:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self didSelectRowAtIndexPath:path];
    }
    [self dismiss];
}


-(NSString *)titleForRowAtIndexPath:(HZIndexPath *)indexPath {
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}


-(void)setMenuWithSelectedRow:(NSInteger)row {
    self.currentSelectedRows[self.currrntSelectedColumn - 1100] = @(row);
}
@end
