//
//  ViewController.m
//  01-Custom Align Rect
//
//  Created by 穆康 on 2017/3/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    CustomView *view01 = [[CustomView alloc] init];
    [self.view addSubview:view01];
    
    view01.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:view01
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:view01
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0];
    [self.view addConstraint:constraint];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
