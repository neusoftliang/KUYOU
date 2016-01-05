//
//  LLCityItinerariesDetailModel.m
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLCityItinerariesDetailModel.h"

@implementation LLCityItinerariesDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"])
    {
        self.desc = value;
    }
}
@end
