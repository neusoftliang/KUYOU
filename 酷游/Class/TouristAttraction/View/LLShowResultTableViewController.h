//
//  LLShowResultTableViewController.h
//  酷游
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLShowResultTableViewController : UITableViewController
//本控制器是被动使用的，所以要展示的数据来源
//就有使用者提供，所以需要公开一个数组，用于存储
//要展示的数据

@property(nonatomic,strong)NSArray *resultArray;

@end
