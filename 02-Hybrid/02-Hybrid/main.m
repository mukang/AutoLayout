//
//  main.m
//  02-Hybrid
//
//  Created by 穆康 on 2017/5/12.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#pragma mark - ViewController Setup

@interface TestBedViewController : UIViewController

@end

@implementation TestBedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *subview = [[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil].lastObject;
    [self.view addSubview:subview];
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint = nil;
    
    // Center it
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    // Set its aspect
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:subview
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    // Constrain it to the superview's size
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                               constant:-40];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:-40];
    [self.view addConstraint:constraint];
    
    // Add a weak "match size" constraint
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                               constant:-40];
    constraint.priority = 100;
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:-40];
    constraint.priority = 100;
    [self.view addConstraint:constraint];
}

@end

#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TestBedAppDelegate class]));
    }
}
