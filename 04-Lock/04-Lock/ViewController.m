//
//  ViewController.m
//  04-Lock
//
//  Created by 穆康 on 2017/6/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "MKLockControl.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lock"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(lock)];
}

- (void)lock {
    self.navigationItem.rightBarButtonItem = nil;
    MKLockControl *lock = [[MKLockControl alloc] init];
    lock.alpha = 0.0;
    [lock addTarget:self action:@selector(lockDidUpdate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:lock];
    
    [lock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        lock.alpha = 1.0;
    }];
}

- (void)lockDidUpdate:(MKLockControl *)lock {
    if (lock.value == 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lock"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(lock)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
