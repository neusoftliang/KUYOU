//
//  LLCityDescModel.m
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLCityDescModel.h"

@implementation LLCityDescModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //判定key如果是description，指定字典的value给desc属性
    if ([key isEqualToString:@"description"])
    {
        self.desc = value;
    }
}
@end
