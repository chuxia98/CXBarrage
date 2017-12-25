//
//  BarrageView.m
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "CXBarrageView.h"
#import "CXBarrageModelProtocol.h"
#import "CALayer+Animate.h"

static NSTimeInterval const kRepeatSec = 0.1;
static NSInteger const kBarrageCount = 5;

@interface CXBarrageView () {
    BOOL _isPause;
}

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *laneWaitTimes;
@property (nonatomic, strong) NSMutableArray *laneLiveTimes;
@property (nonatomic, strong) NSMutableArray *barrageViews;

@end

@implementation CXBarrageView

@synthesize barrageCount = _barrageCount;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}


- (void)pause {
    _isPause = YES;
    [[self.barrageViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimate)];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)resume {
    _isPause = NO;
    [[self.barrageViews valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimate)];
    [self timer];
}

#pragma mark - EVENTS

- (void)tapAction:(UITapGestureRecognizer *)tap {

    CGPoint point = [tap locationInView:tap.view];
    for (UIView *view in self.barrageViews) {
        CGRect frame = view.layer.presentationLayer.frame;
        BOOL b = CGRectContainsPoint(frame, point);
        if (b) {
            if ([self.delegate respondsToSelector:@selector(barrageView:didClickPoint:)]) {
                [self.delegate barrageView:view didClickPoint:point];
            }
            break;
        }
    }
}

- (void)timerAction {
    if (_isPause) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(currentTime)]) {
        return;
    }

    for (int i = 0; i < self.barrageCount; i++) {
        double waitValue = [self.laneWaitTimes[i] doubleValue] - kRepeatSec;
        if (waitValue <= 0.0) {
            waitValue = 0.0;
        }
        self.laneWaitTimes[i] = @(waitValue);

        double leftValue = [self.laneLiveTimes[i] doubleValue] - kRepeatSec;
        if (leftValue <= 0.0) {
            leftValue = 0.0;
        }
        self.laneLiveTimes[i] = @(leftValue);
    }

    [self.barrages sortUsingComparator:^NSComparisonResult(id <CXBarrageModelProtocol> obj1, id <CXBarrageModelProtocol> obj2) {
        if (obj1.beginTime < obj2.beginTime) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];

    NSMutableArray *tmp = [NSMutableArray array];
    for (id <CXBarrageModelProtocol> model in self.barrages) {

        NSTimeInterval beginTime = model.beginTime;
        NSTimeInterval currentTime = self.delegate.currentTime;
        if (beginTime > currentTime) {
            break;
        }

        BOOL b = [self checkBarrageLiveTime:model];
        if (b) {
            [tmp addObject:model];
        }
    }
    [self.barrages removeObjectsInArray:tmp];
}

- (BOOL)checkBarrageLiveTime:(id <CXBarrageModelProtocol>)model {

    CGFloat kBarrageH = self.frame.size.height / self.barrageCount;

    for (int i = 0; i < self.barrageCount; i++) {
        NSTimeInterval waitTime = [self.laneWaitTimes[i] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }

        UIView *view = [self.delegate barrageViewWithModel:model];
        
        NSTimeInterval liveTime = [self.laneLiveTimes[i] doubleValue];
        double speed = (view.frame.size.width + self.frame.size.width) / model.liveTime;
        double distance = liveTime * speed;
        if (distance > self.frame.size.width) {
            continue;
        }

        [self.barrageViews addObject:view];

        self.laneWaitTimes[i] = @(view.frame.size.width / speed);
        self.laneLiveTimes[i] = @(model.liveTime);

        CGRect frame = view.frame;
        frame.origin = CGPointMake(self.frame.size.width, kBarrageH * i);
        view.frame = frame;
        [self addSubview:view];

        [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = view.frame;
            frame.origin.x = - view.frame.size.width;
            view.frame = frame;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [self.barrageViews removeObject:view];
        }];

        return YES;
    }

    return NO;
}

#pragma mark - Private

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self timer];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark set get

- (NSInteger)barrageCount {
    return _barrageCount == 0 ? kBarrageCount : _barrageCount;
}

- (void)setBarrageCount:(NSInteger)barrageCount {
    _barrageCount = barrageCount;
}

- (NSMutableArray *)barrageViews {
    if (!_barrageViews) {
        _barrageViews = [NSMutableArray array];
    }
    return _barrageViews;
}

- (NSMutableArray *)laneLiveTimes {
    if (!_laneLiveTimes) {
        _laneLiveTimes = [NSMutableArray arrayWithCapacity:self.barrageCount];
        for (int i = 0; i < self.barrageCount; i++) {
            _laneLiveTimes[i] = @0.0;
        }
    }
    return _laneLiveTimes;
}

- (NSMutableArray *)laneWaitTimes {
    if (!_laneWaitTimes) {
        _laneWaitTimes = [NSMutableArray arrayWithCapacity:self.barrageCount];
        for (int i = 0; i < self.barrageCount; i++) {
            _laneWaitTimes[i] = @0.0;
        }
    }
    return _laneWaitTimes;
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:kRepeatSec target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (NSMutableArray *)barrages {
    if (!_barrages) {
        _barrages = [NSMutableArray array];
    }
    return _barrages;
}

@end
