//
//  LLPathDailyTableViewController.m
//  酷游
//
//  Created by tarena on 15/12/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLPathDailyTableViewController.h"
#import "LLPathDetailViewController.h"
#import "Masonry.h"
#import "LLPathDailyTableViewCell.h"
@interface LLPathDailyTableViewController ()
@property (strong,nonatomic) NSArray *detailPath;
@property (strong,nonatomic) NSMutableArray *detailPathes;
@end

@implementation LLPathDailyTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.commendPathStr;
    [self.tableView setBounces:NO];
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LLPathDailyTableViewCell" bundle:nil] forCellReuseIdentifier:@"dailyCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itinerModel.itineraries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    self.itinerDetail = [LLMetaDataTool getCityItinerariesDetail:self.itinerModel][section];
    self.detailPath = [LLMetaDataTool getCityItinerDtailPath:self.itinerDetail];
    [self.detailPathes addObject:self.itinerDetail];
    MYLog(@"%lu",(unsigned long)self.itinerDetail.path.count+4);
    return self.itinerDetail.path.count+4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.itinerDetail = [LLMetaDataTool getCityItinerariesDetail:self.itinerModel][indexPath.section];
    self.detailPath = [LLMetaDataTool getCityItinerDtailPath:self.itinerDetail];
    static NSString *CellIdentifier = @"dailyCell";
    LLPathDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = @"介绍";
        cell.contentLabel.text = @"";
        cell.contentLabel.text = self.itinerDetail.desc;
        [cell setSelected:NO];
    }
     else if(indexPath.row==1)
    {
        [cell setSelected:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentLabel.text = @"";
        cell.titleLabel.text = @"餐饮";
        cell.contentLabel.text = self.itinerDetail.dinning;
    }
    else if(indexPath.row==2)
    {
        [cell setSelected:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentLabel.text = @"";
        cell.titleLabel.text = @"住宿";
        cell.contentLabel.text = self.itinerDetail.accommodation;
    }
    else if (indexPath.row==3) {
        [cell setSelected:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = @"旅游路线";
        cell.contentLabel.text = @"";
    }
    else
    {
        [cell setSelected:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        LLCityItinerDetailPathModel *pathModel = self.detailPath[indexPath.row-4];
        cell.titleLabel.text = pathModel.name;
        cell.contentLabel.text = @"详情";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"第%ld天",section+1];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=4)
    {
        self.itinerDetail = [LLMetaDataTool getCityItinerariesDetail:self.itinerModel][indexPath.section];
        self.detailPath = [LLMetaDataTool getCityItinerDtailPath:self.itinerDetail];
        LLPathDetailViewController *path = [LLPathDetailViewController new];
        LLCityItinerDetailPathModel *pathModel = self.detailPath[indexPath.row-4];
        path.pathModel = pathModel;
        [self presentViewController:path animated:YES completion:nil];
    }
}
@end
