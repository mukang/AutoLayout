//
//  MKLockControl.m
//  04-Lock
//
//  Created by 穆康 on 2017/6/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "MKLockControl.h"
#import <Masonry.h>

@interface MKLockControl ()

@property (weak, nonatomic) UIImageView *lockView;
@property (weak, nonatomic) UIImageView *trackView;
@property (weak, nonatomic) UIImageView *thumbView;
@property (strong, nonatomic) MASConstraint *constraint;

@end

@implementation MKLockControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _value = 1;
        [self setup];
        [self setupConstraints];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    self.layer.cornerRadius = 32;
    self.layer.masksToBounds = YES;
    
    UIImageView *lockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockClosed"]];
    [self addSubview:lockView];
    
    UIImageView *trackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track"]];
    trackView.contentMode = UIViewContentModeCenter;
    [self addSubview:trackView];
    
    UIImageView *thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb"]];
    [trackView addSubview:thumbView];
    
    self.lockView = lockView;
    self.trackView = trackView;
    self.thumbView = thumbView;
}

- (void)setupConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(256, 256));
    }];
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).multipliedBy(0.35);
    }];
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(201, 30));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).multipliedBy(0.8);
    }];
    
    CGFloat thumbInset = self.thumbView.image.size.width / 2.0;
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trackView);
        make.left.greaterThanOrEqualTo(self.trackView).offset(thumbInset);
        make.right.lessThanOrEqualTo(self.trackView).offset(-thumbInset);
        self.constraint = make.left.equalTo(self.trackView).offset(0).priority(500);
    }];
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGRect largeTrack = CGRectInset(self.trackView.frame, -20.0, -20.0);
    
    if (!CGRectContainsPoint(largeTrack, touchPoint)) {
        return NO;
    }
    
    touchPoint = [touch locationInView:self.trackView];
    CGRect largeThumb = CGRectInset(self.thumbView.frame, -20.0, -20.0);
    if (!CGRectContainsPoint(largeThumb, touchPoint)) {
        return NO;
    }
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGRect largeTrack = CGRectInset(self.trackView.frame, -20.0, -20.0);
    
    if (!CGRectContainsPoint(largeTrack, touchPoint)) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.constraint setOffset:0];
            [self.trackView layoutIfNeeded];
        }];
        return NO;
    }
    
    touchPoint = [touch locationInView:self.trackView];
    [UIView animateWithDuration:0.1 animations:^{
        [self.constraint setOffset:touchPoint.x];
        [self.trackView layoutIfNeeded];
    }];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self.trackView];
    
    if (touchPoint.x > self.trackView.frame.size.width * 0.75) {
        _value = 0;
        self.userInteractionEnabled = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.constraint setOffset:0];
            [self.trackView layoutIfNeeded];
        }];
    }
    
    if (CGRectContainsPoint(self.trackView.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.constraint setOffset:0];
        [self.trackView layoutIfNeeded];
    }];
}

@end
