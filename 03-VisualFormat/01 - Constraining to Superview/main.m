//
//  main.m
//  01 - Constraining to Superview
//
//  Created by 穆康 on 2017/6/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstraintUtilities-Install.h"

#define ORANGE_COLOR    [UIColor colorWithRed:1.0f green:0.6f blue:0.0f alpha:1.0f]

@interface TestBedViewController : UIViewController

@end

@implementation TestBedViewController {
    NSMutableArray *views;
//    NSArray *constraints;
//    NSLayoutConstraint *constraint;
}

#pragma mark - Constrain Views

void constrainWithinSuperview(UIView *view, float minimumSize, NSUInteger priority) {
    if (!view || !view.superview) {
        return;
    }
    
    for (NSString *format in @[
                               @"H:|->=0@priority-[view(==minimumSize@priority)]",
                               @"H:[view]->=0@priority-|",
                               @"V:|->=0@priority-[view(==minimumSize@priority)]",
                               @"V:[view]->=0@priority-|"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                       options:0
                                                                       metrics:@{
                                                                                 @"priority": @(priority),
                                                                                 @"minimumSize": @(minimumSize)
                                                                                 }
                                                                         views:@{
                                                                                 @"view": view
                                                                                 }];
        [view.superview addConstraints:constraints];
    }
}

#pragma mark - Stretch Views

void stretchToSuperview(UIView *view, CGFloat indent, NSUInteger priority) {
    if (!view || !view.superview) {
        return;
    }
    
    for (NSString *format in @[
                               @"H:|-indent-[view(>=0)]-indent-|",
                               @"V:|-indent-[view(>=0)]-indent-|"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                       options:0
                                                                       metrics:@{@"indent": @(indent)}
                                                                         views:@{@"view": view}];
        [view.superview addConstraints:constraints];
    }
}

#pragma mark - Constrain Size

void constrainViewSize(UIView *view, CGSize size, NSUInteger priority) {
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{
                              @"width": @(size.width),
                              @"height": @(size.height),
                              @"priority": @(priority)
                              };
    
    for (NSString *format in @[
                               @"H:[view(==width@priority)]",
                               @"V:[view(==height@priority)]"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
}

void constrainMinimumViewSize(UIView *view, CGSize size, NSUInteger priority) {
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{
                              @"width": @(size.width),
                              @"height": @(size.height),
                              @"priority": @(priority)
                              };
    
    for (NSString *format in @[
                               @"H:[view(>=width@priority)]",
                               @"V:[view(>=height@priority)]"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
}

void constrainMaximumViewSize(UIView *view, CGSize size, NSUInteger priority) {
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{
                              @"width": @(size.width),
                              @"height": @(size.height),
                              @"priority": @(priority)
                              };
    
    for (NSString *format in @[
                               @"H:[view(<=width@priority)]",
                               @"V:[view(<=height@priority)]"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
}

#pragma mark - Build Row

#define IS_HORIZONTAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllLeft), @(NSLayoutFormatAlignAllRight), @(NSLayoutFormatAlignAllLeading), @(NSLayoutFormatAlignAllTrailing), @(NSLayoutFormatAlignAllCenterX), ] containsObject:@(ALIGNMENT)]

void buildLineWithSpacing(NSArray *views, NSLayoutFormatOptions alignment, NSString *spacing, NSUInteger priority) {
    if (!views.count) {
        return;
    }
    
    UIView *view1, *view2;
    NSInteger axis = IS_HORIZONTAL_ALIGNMENT(alignment);
    NSString *axisString = (axis == 0) ? @"H:" : @"V:";
    NSString *format = [NSString stringWithFormat:@"%@[view1]%@[view2]", axisString, spacing];
    
    for (int i=1; i<views.count; i++) {
        view1 = views[i-1];
        view2 = views[i];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view1, view2);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:alignment metrics:nil views:bindings];
        for (NSLayoutConstraint *con in constraints) {
            [con install:priority];
        }
    }
}

#pragma mark - Matching

void matchSizes(NSArray *views, NSInteger axis, NSUInteger priority) {
    if (!views.count) {
        return;
    }
    
    NSString *format = axis ? @"V:[view2(==view1@priority)]" : @"H:[view2(==view1@priority)]";
    
    UIView *view1 = views[0];
    for (int i=1; i<views.count; i++) {
        UIView *view2 = views[i];
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"priority": @(priority)} views:NSDictionaryOfVariableBindings(view1, view2)];
        for (NSLayoutConstraint *constraint in constraints) {
            [constraint install];
        }
    }
}

#pragma mark - Distribution

NSLayoutAttribute attributeForAlignment(NSLayoutFormatOptions alignment) {
    switch (alignment) {
        case NSLayoutFormatAlignAllLeft:
            return NSLayoutAttributeLeft;
        case NSLayoutFormatAlignAllRight:
            return NSLayoutAttributeRight;
        case NSLayoutFormatAlignAllTop:
            return NSLayoutAttributeTop;
        case NSLayoutFormatAlignAllBottom:
            return NSLayoutAttributeBottom;
        case NSLayoutFormatAlignAllLeading:
            return NSLayoutAttributeLeading;
        case NSLayoutFormatAlignAllTrailing:
            return NSLayoutAttributeTrailing;
        case NSLayoutFormatAlignAllCenterX:
            return NSLayoutAttributeCenterX;
        case NSLayoutFormatAlignAllCenterY:
            return NSLayoutAttributeCenterY;
        case NSLayoutFormatAlignAllBaseline:
            return NSLayoutAttributeBaseline;
        default:
            return NSLayoutAttributeNotAnAttribute;
    }
}

void pseudoDistributionCenters(NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority) {
    if (!views.count) {
        return;
    }
    if (alignment == 0) {
        return;
    }
    
    BOOL horizontal = IS_HORIZONTAL_ALIGNMENT(alignment);
    
    NSLayoutAttribute placementAttribute = horizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
    NSLayoutAttribute endAttribute = horizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeRight;
    
    NSLayoutAttribute alignmentAttribute = attributeForAlignment(alignment);
    
    NSLayoutConstraint *constraint;
    for (int i=0; i<views.count; i++) {
        UIView *view = views[i];
        CGFloat multiplier = ((CGFloat)i + 0.5) / ((CGFloat)views.count);
        
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:placementAttribute
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:view.superview
                                                  attribute:endAttribute
                                                 multiplier:multiplier
                                                   constant:0];
        [constraint install:priority];
        
        constraint = [NSLayoutConstraint constraintWithItem:views[0]
                                                  attribute:alignmentAttribute
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:view
                                                  attribute:alignmentAttribute
                                                 multiplier:1
                                                   constant:0];
        [constraint install:priority];
    }
}

void pseudoDistributeWithSpacers(UIView *superview, NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority) {
    if (!views.count) {
        return;
    }
    if (!superview) {
        return;
    }
    if (alignment == 0) {
        return;
    }
    
    NSMutableArray *spacers = [NSMutableArray array];
    for (int i=0; i<views.count; i++) {
        [spacers addObject:[UIView new]];
        [spacers[i] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [superview addSubview:spacers[i]];
    }
    
    BOOL horizontal = IS_HORIZONTAL_ALIGNMENT(alignment);
    UIView *firstSpacer = spacers[0];
    
    NSString *format = [NSString stringWithFormat:@"%@:[view1][spacer(==firstSpacer)][view2(==view1)]", horizontal ? @"V" : @"H"];
    
    for (int i=1; i<views.count; i++) {
        UIView *view1 = views[i-1];
        UIView *view2 = views[i];
        UIView *spacer = spacers[i-1];
        
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view1, view2, spacer, firstSpacer);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:alignment metrics:nil views:bindings];
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install:priority];
    }
}

#pragma mark - Create Views

UIColor *randomColor() {
    UIColor *theColor = [UIColor colorWithRed:((random() % 255) / 255.0f)
                                        green:((random() % 255) / 255.0f)
                                         blue:((random() % 255) / 255.0f)
                                        alpha:1.0f];
    return theColor;
}

- (void)addViews:(NSInteger)howMany {
    views = [NSMutableArray arrayWithCapacity:howMany];
    
    for (int i=0; i<howMany; i++) {
        UIView *view = [UIView new];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = randomColor();
        [self.view addSubview:view];
        [views addObject:view];
    }
}

#pragma mark - Center View

- (void)centerView:(UIView *)view {
    NSLayoutConstraint *con;
    
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeCenterX
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                       attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0
                                        constant:0];
    [self.view addConstraint:con];
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                       attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                        constant:0];
    [self.view addConstraint:con];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test07];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (UIView *view in self.view.subviews) {
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
    }
}

- (void)test01 {
    [self addViews:1];
    for (int i=0; i<1; i++) {
        constrainWithinSuperview(views[i], 100, 1);
    }
}

- (void)test02 {
    [self addViews:4];
    for (int i=0; i<4; i++) {
        stretchToSuperview(views[i], 20 * (i + 1), 500);
    }
}

- (void)test03 {
    [self addViews:4];
    for (int i=0; i<4; i++) {
        [self centerView:views[i]];
//        constrainViewSize(views[i], CGSizeMake((8-i)*20, (8-i)*20), 500);
//        constrainMaximumViewSize(views[i], CGSizeMake((8-i)*20, (8-i)*20), 500);
        constrainMinimumViewSize(views[i], CGSizeMake((8-i)*20, (8-i)*20), 500);
    }
}

- (void)test04 {
    [self addViews:6];
    
    for (UIView *view in views) {
        constrainViewSize(view, CGSizeMake(40, 40), 1);
    }
    
    NSArray *constraints;
    UIView *view = views[0];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": view}];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": view}];
    [self.view addConstraints:constraints];
    
    buildLineWithSpacing(views, NSLayoutFormatAlignAllCenterX, @"-", 500);
}

- (void)test05 {
    [self addViews:6];
    
    NSArray *constraints;
    UIView *view = views[0];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view": view}];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": view}];
    [self.view addConstraints:constraints];
    
    constrainViewSize(views[0], CGSizeMake(40, 40), 1);
    buildLineWithSpacing(views, NSLayoutFormatAlignAllCenterX, @"-", 500);
    matchSizes(views, 0, 500);
    matchSizes(views, 1, 500);
}

- (void)test06 {
    [self addViews:6];
    
    CGFloat side = 60;
    
    for (int i=0; i<6; i++) {
        UIView *view = views[i];
        NSArray *constraints;
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(size)]" options:0 metrics:@{@"size": @(side)} views:NSDictionaryOfVariableBindings(view)];
        for (NSLayoutConstraint *constraint in constraints) {
            [constraint install:300];
        }
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(size)]" options:0 metrics:@{@"size": @(side)} views:NSDictionaryOfVariableBindings(view)];
        for (NSLayoutConstraint *constraint in constraints) {
            [constraint install:300];
        }
    }
    
    pseudoDistributionCenters(views, NSLayoutFormatAlignAllCenterY, 1000);
}

- (void)test07 {
    [self addViews:6];
    
    CGFloat side = 60;
    
    for (int i=0; i<6; i++) {
        UIView *view = views[i];
        NSArray *constraints;
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(size)]" options:0 metrics:@{@"size": @(side)} views:NSDictionaryOfVariableBindings(view)];
        for (NSLayoutConstraint *constraint in constraints) {
            [constraint install:300];
        }
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(size)]" options:0 metrics:@{@"size": @(side)} views:NSDictionaryOfVariableBindings(view)];
        for (NSLayoutConstraint *constraint in constraints) {
            [constraint install:300];
        }
    }
    
    pseudoDistributeWithSpacers(self.view, views, NSLayoutFormatAlignAllCenterY, 1000);
    
    UIView *firstView = views[0];
    UIView *lastView = [views lastObject];
    NSArray *constraints;
    
    // Pin first view left, and to the top
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[firstView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(firstView)];
    [self.view addConstraints:constraints];
    
    // Pin last view right
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)];
    [self.view addConstraints:constraints];
}

@end

#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;

@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TestBedViewController *vc = [[TestBedViewController alloc] init];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TestBedAppDelegate class]));
    }
}
