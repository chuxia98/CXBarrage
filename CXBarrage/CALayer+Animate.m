//
//  CALayer+Animate.m
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "CALayer+Animate.h"

@implementation CALayer (Animate)

- (void)pauseAnimate {
    CFTimeInterval time = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = time;
}

- (void)resumeAnimate {
    CFTimeInterval time = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval begin = [self convertTime:CACurrentMediaTime() fromLayer:nil] - time;
    self.beginTime = begin;
}

@end
