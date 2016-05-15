//
//  DropDownMenuList.h
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface HZIndexPath : NSObject
@property (nonatomic, assign) NSInteger  row; // 行
@property (nonatomic, assign) NSInteger  column; //列

+(instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;

@end

@class DropDownMenuList;

@protocol DropDownMenuListDataSouce <NSObject>
@required
// 设置多少行显示
-(NSInteger)menu:(DropDownMenuList *)menu numberOfRowsInColum:(NSInteger)column;

-(NSString *)menu:(DropDownMenuList *)menu titleForRowAtIndexPath:(HZIndexPath *)indexPath;

-(NSMutableArray *)menuNumberOfRowInColumn;
@optional
// 每行图片
-(NSString *)menu:(DropDownMenuList *)menu imageNameForRowAtIndexPath:(HZIndexPath *)indexPath;
 @end


@protocol DropDownMenuListDelegate <NSObject>
@optional
- (void)menu:(DropDownMenuList *)segment didSelectRowAtIndexPath:(HZIndexPath *)indexPath;
- (void)menu:(DropDownMenuList *)segment didSelectTitleAtColumn:(NSInteger)column;

@end


@interface DropDownMenuList : UIView<UITableViewDataSource,UITableViewDelegate>


// 显示
+(instancetype)show:(CGPoint)orgin andHeight:(CGFloat)height;


// 代理
@property (nonatomic, weak) id<DropDownMenuListDelegate>  delegate;
@property (nonatomic, weak) id<DropDownMenuListDataSouce>  dataSource;

//##################################


// 获取Title
-(NSString *)titleForRowAtIndexPath:(HZIndexPath *)indexPath;
// 默认选中
-(void)selectDefaultIndexPath;


-(instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height;

@end
