//
//  LLPopTableViewController.m
//  酷游
//
//  Created by tarena on 15/12/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLPopTableViewController.h"
#import "LLCityDescTableViewController.h"
#import "LLMetaDataTool.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface LLPopTableViewController ()<UISearchBarDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic)NSArray *popCitiesArray;
///增加属性：用于记录搜索控制器
@property(nonatomic,strong)UISearchController *searchController;
///增加属性：用于记录搜索控制器
@property(nonatomic,strong)UISearchBar *searchBar;
///增加属性：用于展示搜索结果的表视图控制器
/**
 *  全部城市名称
 */
@property (strong,nonatomic) NSArray *allCitites;

@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) NSString *cityName;

@end

@implementation LLPopTableViewController
NSString *section1 = @"当前所在城市";
NSString *section2 = @"热门分类";
- (NSArray *)allCitites {
    if(_allCitites == nil) {
        _allCitites = [[NSArray alloc] init];
        _allCitites = [LLMetaDataTool cities];
    }
    return _allCitites;
}

- (NSArray *)popCitiesArray
{
    if(_popCitiesArray == nil)
    {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"cityGroups" ofType:@"plist"];
        NSArray *list = [NSArray arrayWithContentsOfFile:filePath];
        NSDictionary *dic = list[0];
        _popCitiesArray = dic[@"cities"];;
    }
    return _popCitiesArray;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cityModel"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LLCityModel *city = [LLCityModel new];
        if (indexPath.section==0) {
            city.name = self.cityName;
        }else
        {
            city.name = self.popCitiesArray[indexPath.row];
        }
        LLCityDescTableViewController *tableController = segue.destinationViewController;
        tableController.city = city;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSearchFunction];
    [self getCurrentLocation];
    [self showAlert];
    self.cityName = @"北京";
}

/**
 *  显示提示框
 */
-(void)showAlert
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeText;
    progress.labelText = @"正在定位当前城市,请稍后...";
    [progress hide:YES afterDelay:2];
    //[progress removeFromSuperview];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return self.popCitiesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section==0)
    {
        cell.textLabel.text = self.cityName;
    }
    else
    {
        cell.textLabel.text = self.popCitiesArray[indexPath.row];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return section1;
    }else
        return section2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransition *ca=[CATransition animation];
    //1.1告诉要执行什么动画
    //1.2设置过度效果
    ca.type=kCATransitionReveal;
    //1.3设置动画的过度方向（向右）
    ca.subtype=kCATransitionFromRight;
     //1.4设置动画的时间
    ca.duration=1.0;
     //1.5设置动画的起点
    ca.startProgress=0.5;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];
    [self performSegueWithIdentifier:@"cityModel" sender:indexPath];
}
#pragma mark --- UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    section2 = @"搜索结果";
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    NSLog(@"编辑完成执行操作");
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
/**
 *  配置搜索控制器
 */
-(void)configSearchFunction
{
    /**
     *  创建搜索控制器的实例
     */
    self.searchBar = [[UISearchBar alloc]init];
    /**
     *  设置搜索条的尺寸为自适应
     */
    [self.searchBar sizeToFit];
    /** 在当前主控制器的表头添加searchBar*/
//    self.navigationItem.titleView = self.searchBar;
    self.tableView.tableHeaderView = self.searchBar;
    /** 设置搜索控制器的结果更新代理对象*/
    // 所以设置searchBar的代理
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchBar];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *searchResult =self.searchBar.text;
    
        //到self.allProducts中逐一比对数据
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (LLCityModel *city in self.allCitites) {
        NSRange range = [city.name rangeOfString:searchResult];
        // 如果名称匹配 且类别相同
        // 则将此产品记录到结果数组中
        if (range.length>0 ) {
            [resultArray addObject:city.name];
        }
    }
    self.popCitiesArray = resultArray;
    // 将要展示的数据结果给 负责显示的vc传过去
    //self.showResultVC.resultArray = resultArray;
    
    // 更新视图显示数据
    [self.tableView reloadData];
    
}
#pragma mark --- 进行定位
- (CLGeocoder *)geocoder {
    if(_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(void)getCurrentLocation
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0) {
        //征求用户是否愿意前台和后台都定位
        //        [self.manager requestAlwaysAuthorization];
        //征求用户是否愿意只在前台定位(Info.plist添加key)
        [self.manager requestWhenInUseAuthorization];
    } else {
        //直接定位(不需要征求用户同意)
        [self.manager startUpdatingLocation];
    }
}
#pragma mark --- CLLocationManagerDelegat
//查看用户是否同意

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            //用户允许在使用期间定位(前台)
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            //设定定位精确度
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            //开始定位操作
            [self.manager startUpdatingLocation];
            break;
            //用户不允许定位(第二种方案)
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户不允许");
            break;
        default:
            break;
    }
    
}
//已经定位到用户的位置

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"latitude:%f; longitude:%f", location.coordinate.latitude, location.coordinate.longitude);
    self.location = location;
    //停止定位
    [self.manager stopUpdatingLocation];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error)
        {
            for (CLPlacemark *placemark in placemarks)
            {
                //详细信息
                NSLog(@"详细信息:%@", placemark.addressDictionary);
                self.cityName = placemark.addressDictionary[@"SubLocality"];
                [self.tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }
    }];
    
}
/**
 *  重新进行定位
 */
- (IBAction)reloadLocation:(id)sender
{
    [self showAlert];
    [self getCurrentLocation];
}
@end
