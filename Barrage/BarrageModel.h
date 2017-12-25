//
//  BarrageModel.h
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXBarrageModelProtocol.h"

@interface BarrageModel : NSObject <CXBarrageModelProtocol>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval beginTime;
@property (nonatomic, assign) NSTimeInterval liveTime;

@end
