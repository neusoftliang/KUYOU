//
//  LLCityDescModel.h
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLCityDescModel : NSObject
@property (strong,nonatomic) NSString *cityid;
@property (nonatomic,strong)NSString * cityname;
@property (nonatomic,strong)NSDictionary *location;
@property (nonatomic,strong)NSString * star;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *abstract;
@property (nonatomic,strong)NSString *desc;
@property (strong,nonatomic)NSArray *itineraries;
@end
