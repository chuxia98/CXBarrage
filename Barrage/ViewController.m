//
//  ViewController.m
//  Barrage
//
//  Created by chen on 2017/12/25.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"
#import "CXBarrageView.h"
#import "BarrageModel.h"

@interface ViewController () <CXBarrageViewDelegate>

@property (nonatomic, strong) CXBarrageView *barrageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.barrageView = [[CXBarrageView alloc] init];
    self.barrageView.delegate = self;
    self.barrageView.backgroundColor = [UIColor orangeColor];
    self.barrageView.frame = CGRectMake(100, 30, 200, 300);
    [self.view addSubview:self.barrageView];
}

- (IBAction)pause {
    [self.barrageView pause];
}

- (IBAction)resume {
    [self.barrageView resume];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BarrageModel *model1 = [[BarrageModel alloc] init];
    model1.beginTime = 0;
    model1.liveTime = 5;
    model1.content = [NSString stringWithFormat:@"cyh ++ 123"];

    BarrageModel *model2 = [[BarrageModel alloc] init];
    model2.beginTime = .2;
    model2.liveTime = 8;
    model2.content = @"想嘻嘻";

    [self.barrageView.barrages addObject:model1];
    [self.barrageView.barrages addObject:model2];
}

#pragma mark - <BarrageViewDelegate>

- (NSTimeInterval)currentTime {
    static NSTimeInterval time = 0.0;
    time += 0.1;
    return time;
}

- (UIView *)barrageViewWithModel:(BarrageModel *)model {
    UILabel *label = [UILabel new];
    label.text = model.content;
    [label sizeToFit];
    return label;
}

- (void)barrageView:(UIView *)barrageView didClickPoint:(CGPoint)point {
    NSLog(@"did click view - %@ %@", barrageView, NSStringFromCGPoint(point));
}

@end
