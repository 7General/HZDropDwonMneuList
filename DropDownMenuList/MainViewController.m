//
//  MainViewController.m
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"
#import "DropDownMenuList.h"

@interface MainViewController ()<DropDownMenuListDelegate,DropDownMenuListDataSouce>

@property (nonatomic, strong) UITableView * myTableView;


@property (nonatomic, strong) NSMutableArray * sort;
@property (nonatomic, strong) NSMutableArray * classIfy;


@property (nonatomic, strong) DropDownMenuList * dropMenu;

@end

@implementation MainViewController

-(NSMutableArray *)sort {
    if (_sort == nil) {
        _sort = [NSMutableArray new];
        [_sort addObject:@"1"];
        [_sort addObject:@"2"];
        [_sort addObject:@"3"];
        [_sort addObject:@"4"];
        [_sort addObject:@"5"];
        [_sort addObject:@"6"];
    }
    return _sort;
}
-(NSMutableArray *)classIfy {
    if (!_classIfy) {
        _classIfy = [NSMutableArray new];
        [_classIfy addObject:@"7"];
        [_classIfy addObject:@"8"];
        [_classIfy addObject:@"9"];
        [_classIfy addObject:@"0"];
        [_classIfy addObject:@"10"];
        [_classIfy addObject:@"11"];
    }
    return _classIfy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDMColor(192, 191, 192);
    

    
    self.dropMenu = [DropDownMenuList show:CGPointMake(0, 200) andHeight:44];
    self.dropMenu.delegate = self;
    self.dropMenu.dataSource = self;
    [self.view addSubview:self.dropMenu];
    
}
-(void)menu:(DropDownMenuList *)segment didSelectTitleAtColumn:(NSInteger)column{

//    if (column == 1100) {
//        [self.dataArry removeAllObjects];
//        [self.dataArry addObject:@"1"];
//        [self.dataArry addObject:@"2"];
//        [self.dataArry addObject:@"3"];
//        [self.dataArry addObject:@"4"];
//        [self.dataArry addObject:@"5"];
//        [self.dataArry addObject:@"6"];
//        
//        [self.myTableView reloadData];
//    }
//    
//    if (column == 1101) {
//        [self.dataArry removeAllObjects];
//        [self.dataArry addObject:@"7"];
//        [self.dataArry addObject:@"8"];
//        [self.dataArry addObject:@"9"];
//        [self.dataArry addObject:@"10"];
//        [self.dataArry addObject:@"11"];
//        [self.dataArry addObject:@"12"];
//        
//        [self.myTableView reloadData];
//    }
}

-(NSMutableArray *)menuNumberOfRowInColumn {
    return @[@"全国",@"所有税种"].mutableCopy;
}

-(NSInteger)menu:(DropDownMenuList *)menu numberOfRowsInColum:(NSInteger)column {
    if (column == 0) {
        return self.sort.count;
    }else {
        return self.classIfy.count;
    }
}

-(NSString *)menu:(DropDownMenuList *)menu titleForRowAtIndexPath:(HZIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        return self.sort[indexPath.row];
    }else {
        return self.classIfy[indexPath.row];
    }
}
-(void)menu:(DropDownMenuList *)segment didSelectRowAtIndexPath:(HZIndexPath *)indexPath {
    NSLog(@"------%ld----->>>%ld",indexPath.column,indexPath.row);
}







@end
