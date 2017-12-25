//
//  BarrageView.h
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXBarrageModelProtocol;
@protocol CXBarrageViewDelegate;

@interface CXBarrageView : UIView

@property (nonatomic, assign) NSInteger barrageCount;

@property (nonatomic, weak) id <CXBarrageViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray <id <CXBarrageModelProtocol>> *barrages;

- (void)pause;
- (void)resume;

@end

@protocol CXBarrageViewDelegate <NSObject>

@property (nonatomic, readonly) NSTimeInterval currentTime;

- (UIView *)barrageViewWithModel:(id <CXBarrageModelProtocol>)model;

- (void)barrageView:(UIView *)barrageView didClickPoint:(CGPoint)point;

@end
