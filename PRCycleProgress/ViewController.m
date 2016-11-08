//
//  ViewController.m
//  PRCycleProgress
//
//  Created by weixu on 16/11/4.
//  Copyright © 2016年 weixu. All rights reserved.
//

#import "ViewController.h"
#import "CycleProgressView.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(CycleProgressView) NSArray *cycleProgressViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)valueChanged:(id)sender {
    CGFloat value = [(UISlider *)sender value];
        
    for (CycleProgressView *view in _cycleProgressViews) {
        
        view.textColor = [UIColor blueColor];
        view.circleWidth = 10;
        view.clockwise = YES;
        view.isGradual = YES;
        
        view.progressTopGradientColor = [UIColor redColor];
        view.progressBottomGradientColor = [UIColor blueColor];
        
        NSMethodSignature *signature =  [view methodSignatureForSelector:@selector(setProgressRatio:)];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:view];
        [invocation setSelector:@selector(setProgressRatio:)];
        [invocation setArgument:&value atIndex:2];
        
        [invocation invoke];
    }
    
}


@end
