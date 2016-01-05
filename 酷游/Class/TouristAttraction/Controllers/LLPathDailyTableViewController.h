//
//  LLPathDailyTableViewController.h
//  酷游
//
//  Created by tarena on 15/12/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLMetaDataTool.h"
@interface LLPathDailyTableViewController : UITableViewController
@property (strong,nonatomic) NSArray *itinerariesDetail;
@property (assign,nonatomic) NSInteger selectedRow;
@property (strong,nonatomic) LLCityItinerariesDetailModel *itinerDetail;
@property (strong,nonatomic) NSString *commendPathStr;
@property (strong,nonatomic) LLCityItinerariesModel *itinerModel;
@end
