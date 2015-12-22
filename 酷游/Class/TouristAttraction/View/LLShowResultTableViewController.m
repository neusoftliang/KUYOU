//
//  LLShowResultTableViewController.m
//  酷游
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLShowResultTableViewController.h"
#import "LLMetaDataTool.h"
#import "LLCityDescTableViewController.h"
@interface LLShowResultTableViewController ()
@property (nonatomic,strong) UINavigationController *nav;
@end

@implementation LLShowResultTableViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"citysegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LLCityModel *city = [LLCityModel new];
        city= self.resultArray[indexPath.row];
        LLCityDescTableViewController *tableController = segue.destinationViewController;
        tableController.city = city;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav = [[UINavigationController alloc]initWithRootViewController:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    LLCityModel *city = self.resultArray[indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LLCityDescTableViewController *descTable = [storyboard instantiateViewControllerWithIdentifier:@"citydesc"];
    LLCityModel *city = [LLCityModel new];
    city= self.resultArray[indexPath.row];
    descTable.city = city;
    [self.nav pushViewController:descTable animated:YES];
}

@end
