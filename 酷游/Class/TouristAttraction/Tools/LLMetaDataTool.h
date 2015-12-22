//
//  LLMetaDataTool.h
//  酷游
//
//  Created by tarena on 15/12/6.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCityModel.h"
#import "LLCityDescModel.h"
#import "LLCityItinerariesModel.h"
#import "LLCityItinerariesDetailModel.h"
#import "LLCityItinerDetailPathDescModel.h"
#import "LLCityItinerDetailPathModel.h"
@interface LLMetaDataTool : NSObject
//返回所有城市的方法(数组:TRCity)
@property (strong,nonatomic) NSArray *array;
+ (NSArray *)cities;
//给定城市，返回城市描述模型
+(void)getCityDesc:(LLCityModel *)city returnBlock:(void(^)(LLCityDescModel* cityDescModel))returnblock;
//给定城市描述，返回城市中推荐出行行程
+(NSArray *)getCityItineraries:(LLCityDescModel*)cityDesc;
//给定推荐出行行程，返回推荐出行行程详情
+(NSArray *)getCityItinerariesDetail:(LLCityItinerariesModel *)cityItineraties;
//给定推荐出行行程详情，返回具体游玩景点路线
+(NSArray *)getCityItinerDtailPath:(LLCityItinerariesDetailModel*)cityItineratiesDetail;
//给定出游玩路线，返回具体景点介绍
+(void)getCityItinerDetailPathDesc:(LLCityItinerDetailPathModel*)touristAttraction returnBlock:(void(^)(LLCityItinerDetailPathDescModel* cityDescModel))returnblock;

@end
