//
//  LLNetConnTool.h
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNetConnTool : NSObject
+(void)ConnNetByPostWithURL:(NSString*)url AndParamerters:(id)paramerter isSuccess:(void(^)(NSDictionary* dic))successBlock Failed:(void(^)(NSError *error))errorBlock;

+(void)ConnNetByGetWithURL:(NSString*) url AndParamerters:(id)paramerter isSuccess:(void(^)(NSDictionary* dic))successBlock Failed:(void(^)(NSError *error))errorBlock;
@end
