//
//  LLNetConnTool.m
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLNetConnTool.h"
#import "AFNetworking.h"
@implementation LLNetConnTool
+(void)ConnNetByGetWithURL:(NSString *)url AndParamerters:(id)paramerter isSuccess:(void (^)(NSDictionary *))successBlock Failed:(void (^)(NSError *))errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"cad019fe72bf309b500e493fff396287" forHTTPHeaderField:@"apikey"];
    [manager GET:url parameters:paramerter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //MYLog(@"%@",responseObject);
        successBlock(responseObject);
        MYLog(@"url%@",operation.request.URL);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

+(void)ConnNetByPostWithURL:(NSString *)url AndParamerters:(id)paramerter isSuccess:(void (^)(NSDictionary *))successBlock Failed:(void (^)(NSError *))errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:paramerter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successBlock(responseObject);
        //MYLog(@"url%@",operation.userInfo);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}
@end
