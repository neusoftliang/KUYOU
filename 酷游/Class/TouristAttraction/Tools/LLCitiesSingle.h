//
//  LLCitiesSingle.h
//  酷游
//
//  Created by tarena on 15/12/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLCitiesSingle : NSObject
@property (strong,nonatomic) NSArray *array;
+(id)sharedCities;
@end
