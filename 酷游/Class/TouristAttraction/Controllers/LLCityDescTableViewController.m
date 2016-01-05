//
//  LLCityDescTableViewController.m
//  酷游
//
//  Created by tarena on 15/12/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLCityDescTableViewController.h"
#import "LLMetaDataTool.h"
#import "PellTableViewSelect.h"
#import "LLPathDailyTableViewController.h"
#import "LLCityDescCell.h"
@interface LLCityDescTableViewController ()<UIPopoverPresentationControllerDelegate>
@property (strong,nonatomic) LLCityDescModel *cityDescription;
@property (assign,nonatomic) CGFloat labelHeight;
@end

@implementation LLCityDescTableViewController

-(void)setCity:(LLCityModel *)city
{
    _city = city;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"citybg"]];
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.estimatedRowHeight = 44.0f;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self setUpload];
}
-(void)setUpload
{
     __weak LLCityDescTableViewController * weakSelf = self;
    [LLMetaDataTool getCityDesc:self.city returnBlock:^(LLCityDescModel *cityDescModel) {
        weakSelf.cityDescription = cityDescModel;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cityNameCell"];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if (self.cityDescription==nil) {
            cell.textLabel.text = @"城市名";
            cell.textLabel.textColor = [UIColor whiteColor];
        }else
            cell.textLabel.text = self.cityDescription.cityname;
        [cell setSelected:NO];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    if (indexPath.row==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell setSelected:NO];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    if (indexPath.row==2) {
        LLCityDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityDesc"];
        if (cell==nil) {
            cell = [[LLCityDescCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cityDesc"];
        }
        cell.contextLabel.text = self.cityDescription.desc;
        cell.contextLabel.textColor = [UIColor whiteColor];
        UIFont *font = [UIFont fontWithName:@"AmericanTypewriter-CondensedBold " size:18];
        cell.contextLabel.font = font;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        return UITableViewAutomaticDimension;
    }else
        return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak LLCityDescTableViewController *weakSelf = self;
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 100, 300) selectData:self.cityDescription action:^(NSInteger index) {
        LLPathDailyTableViewController *pathDaily = [LLPathDailyTableViewController new];
        LLCityItinerariesModel *itier = [LLMetaDataTool getCityItineraries:self.cityDescription][index];
        pathDaily.itinerariesDetail = [LLMetaDataTool getCityItinerariesDetail:itier];
        pathDaily.selectedRow = index;
        pathDaily.commendPathStr = itier.name;
        pathDaily.itinerModel = itier;
        
        CATransition *ca=[CATransition animation];
        //1.1告诉要执行什么动画
        //1.2设置过度效果
        ca.type=@"suckEffect";
        //1.3设置动画的过度方向（向右）
        ca.subtype=kCATransitionFromRight;
        //1.4设置动画的时间
        ca.duration=1.0;
        //1.5设置动画的起点
        ca.startProgress=0.5;
        [weakSelf.navigationController.view.layer addAnimation:ca forKey:nil];
        [weakSelf.navigationController pushViewController:pathDaily animated:YES];
    } animated:YES];
}
@end
