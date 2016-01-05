//
//  LLMetaDataTool.m
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "LLMetaDataTool.h"
#import "MJExtension.h"
#import "LLNetConnTool.h"
@implementation LLMetaDataTool

+ (NSArray *)cities
{
    return [LLCityModel mj_objectArrayWithFilename:@"cities.plist"];
}
//给定城市，返回城市描述模型

+(void)getCityDesc:(LLCityModel *)city returnBlock:(void (^)(LLCityDescModel *))returnblock

{
    __block LLCityDescModel *model = [LLCityDescModel new];
    NSString *httpUrl = @"http://apis.baidu.com/apistore/travel/line";
    NSString *httpArg = [NSString stringWithFormat:@"location=%@&day=all&output=json&coord_type=bd09ll&out_coord_type=bd09ll",city.name];
    //[self request: httpUrl withHttpArg: httpArg];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl,httpArg];
    NSString *URLStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [LLNetConnTool ConnNetByGetWithURL:URLStr AndParamerters:nil isSuccess:^(NSDictionary *dic) {
        
        if (![dic[@"message"] isEqualToString:@"服务内部错误"]) {
            MYLog(@"get%@",dic);
            NSDictionary *result = dic[@"result"];
            [LLCityDescModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"desc":@"description"
                         };
            }];
            model = [LLCityDescModel mj_objectWithKeyValues:result];
            returnblock(model);
            MYLog(@"meta%@",model.cityname);
        }
        
    } Failed:^(NSError *error) {
        MYLog(@"错误%@",error.userInfo);
    }];
}
//给定城市描述，返回城市中推荐出行行程
+(NSArray *)getCityItineraries:(LLCityDescModel*)cityDesc
{
    NSMutableArray *mutableArray = [NSMutableArray array] ;
    for (NSDictionary *dic in cityDesc.itineraries)
    {
        [LLCityItinerariesModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"desc":@"description"
                     };
        }];
        [mutableArray addObject:[LLCityItinerariesModel mj_objectWithKeyValues:dic]];
    }
    return [mutableArray copy];
}
//给定推荐出行行程，返回推荐出行行程详情
+(NSArray *)getCityItinerariesDetail:(LLCityItinerariesModel *)cityItineraties
{
    NSMutableArray *mutableArray = [NSMutableArray array] ;
    for (NSDictionary *dic in cityItineraties.itineraries)
    {
        [LLCityItinerariesDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"desc":@"description"
                     };
        }];
        [mutableArray addObject:[LLCityItinerariesDetailModel mj_objectWithKeyValues:dic]];
    }
    return [mutableArray copy];
}
//给定推荐出行行程详情，返回具体游玩景点路线
+(NSArray *)getCityItinerDtailPath:(LLCityItinerariesDetailModel*)cityItineratiesDetail
{
    NSMutableArray *mutableArray = [NSMutableArray array] ;
    for (NSDictionary *dic in cityItineratiesDetail.path)
    {
        
        [mutableArray addObject:[LLCityItinerDetailPathModel mj_objectWithKeyValues:dic]];
    }
    return [mutableArray copy];
}
//给定出游玩路线，返回具体景点介绍
+(void)getCityItinerDetailPathDesc:(LLCityItinerDetailPathModel *)touristAttraction returnBlock:(void (^)(LLCityItinerDetailPathDescModel *))returnblock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    __block LLCityItinerDetailPathDescModel *detail = [LLCityItinerDetailPathDescModel new];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    NSString *url = @"https://route.showapi.com/268-1?";
    parameters[@"showapi_appid"] = @"13447";
    parameters[@"showapi_sign"] = @"da14f71cb1a140f5b37d26760c829bc3";
    parameters[@"showapi_timestamp"] = locationString;
    parameters[@"keyword"] = touristAttraction.name;
    
    [LLNetConnTool ConnNetByPostWithURL:url AndParamerters:parameters isSuccess:^(NSDictionary *dic) {
        NSDictionary *dDic = [[NSDictionary alloc]init];
        dDic = dic[@"showapi_res_body"][@"pagebean"][@"contentlist"][0];
        detail = [LLCityItinerDetailPathDescModel mj_objectWithKeyValues:dDic];
        returnblock(detail);
        
    } Failed:^(NSError *error) {
        MYLog(@"失败：%@",error.userInfo);
    }];
}
@end
