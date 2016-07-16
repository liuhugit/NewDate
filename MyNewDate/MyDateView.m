//
//  MyDateView.m
//  rili
//
//  Created by 刘虎 on 16/7/13.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "MyDateView.h"
#import "MyCollectionViewCell.h"
@interface MyDateView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSArray *_weekArray;
}

@property (nonatomic,strong)UILabel *topLabel;//顶部

@property (nonatomic,strong)UIButton *leftButton;

@property (nonatomic,strong)UIButton *rightButton;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)NSArray *weekDayArray;


@end

@implementation MyDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/


- (void)drawRect:(CGRect)rect{
    _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    [self addSubview:self.collectionView];
    [self addSubview:self.topLabel];
    [self buildTwoButton];
}

- (void)buildTwoButton{
    NSArray *array = @[@"上一个",@"下一个"];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * (375 - 80), 25, 60, 30);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(action_button:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 + i;
        [self addSubview:button];
    }
}

- (void)action_button:(UIButton *)sender{
    switch (sender.tag) {
        case 200:{
            [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
                self.date = [self lastMonth:self.date];
            } completion:nil];
        }break;
        case 201:{
           self.date = [self nextMonth:_date];
            [self.collectionView reloadData];
        }break;
        default:
            break;
    }
}

- (void)setDate:(NSDate *)date{
    _date = date;
    _topLabel.text = [NSString stringWithFormat:@"%ld-%ld",[self year:self.date],[self month:self.date]];
    [_collectionView reloadData];
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 375, 40)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = [UIColor blackColor];
        _topLabel.text = [NSString stringWithFormat:@"%ld-%ld",[self year:self.date],[self month:self.date]];
    }
    return _topLabel;
}

#pragma mark -- date
//得到今天是几号
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//得到今天是几月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
//得到今年是几年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//第一周的第一天在什么位置
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

//这个月有多少天
- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

//上个月的date数据（用于刷新）
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//下个月的date数据（用于刷新）
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark -- collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _weekArray.count;
    }else{
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.dateLabel.text = _weekArray[indexPath.row];
        cell.dateLabel.textColor = [UIColor whiteColor];
    }else{
        NSInteger daysInThisMonth = [self totaldaysInThisMonth:_date];
        NSInteger firstWeekDay = [self firstWeekdayInThisMonth:_date];

        NSInteger day = 0;
        NSInteger i = indexPath.row;
        if (i < firstWeekDay) {
            cell.dateLabel.text = @"";
        }else if (i > firstWeekDay + daysInThisMonth - 1){
            cell.dateLabel.text = @"";
        }else{
            day = i - firstWeekDay + 1;
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
            cell.dateLabel.textColor = [UIColor blackColor];
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    cell.dateLabel.textColor = [UIColor redColor];
                }else if (day > [self day:_date]){
                    cell.dateLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                }
            }else if ([_today compare:_date] == NSOrderedAscending){
                cell.dateLabel.textColor = [UIColor blueColor];
            }
        }
    }
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    }else if (indexPath.section == 1){
        if (cell.dateLabel.text.length == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor orangeColor];
        }
    }
    return cell;

}


- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumInteritemSpacing = 15/6;
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(50, 50);
        _flowLayout.sectionInset = UIEdgeInsetsMake(30, 5, 0, 5);
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, 375, 500) collectionViewLayout:self.flowLayout];
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
@end




























