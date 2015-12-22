//
//  LLCityItinerariesModel.m
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLCityItinerariesModel.h"

@implementation LLCityItinerariesModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"])
    {
        self.desc = value;
    }
}
@end
