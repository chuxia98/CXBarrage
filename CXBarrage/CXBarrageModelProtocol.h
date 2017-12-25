//
//  BarrageModelProtocol.h
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXBarrageModelProtocol <NSObject>

@required
@property (nonatomic, readonly) NSTimeInterval beginTime;
@property (nonatomic, readonly) NSTimeInterval liveTime;

@end
