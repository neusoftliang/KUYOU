//
//  LLCitiesSingle.m
//  酷游
//
//  Created by tarena on 15/12/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLCitiesSingle.h"
#import "LLMetaDataTool.h"
@implementation LLCitiesSingle

-(id)init
{
    if (self = [super init])
    {
        self.array = [LLMetaDataTool cities];
    }
    return self;
}

+(id)sharedCities
{
    static LLCitiesSingle * single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[LLCitiesSingle alloc]init];
    });
    return single;
}
@end
