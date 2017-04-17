//
//  CustomView.m
//  01-Custom Align Rect
//
//  Created by 穆康 on 2017/3/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "CustomView.h"

#define ORANGE_COLOR    [NSColor colorWithDeviceRed:1 green:0.6 blue:0 alpha:1]
#define AQUA_COLOR    [NSColor colorWithDeviceRed:0 green:0.6745 blue:0.8039 alpha:1]

@implementation CustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path;
    
    // Calculate offset from frame for 170x170 art
    CGFloat dx = (self.frame.size.width - 170) / 2.0;
    CGFloat dy = (self.frame.size.height - 170);
    
    // Draw a shadow
    NSRect rect = NSMakeRect(8+dx, -8+dy, 160, 160);
    path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:32 yRadius:32];
    [[[NSColor blackColor] colorWithAlphaComponent:0.3f] set];
    [path fill];
    
    // Draw shape with outline
    rect.origin = CGPointMake(dx, dy);
    path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:32 yRadius:32];
    [[NSColor blackColor] set];
    path.lineWidth = 6;
    [path stroke];
    
    [ORANGE_COLOR set];
    [path fill];
}

- (NSSize)intrinsicContentSize {
    return NSMakeSize(170, 170);
}

#define USE_ALIGNMENT_RECTS 1
#if USE_ALIGNMENT_RECTS
- (NSRect)frameForAlignmentRect:(NSRect)alignmentRect {
    CGFloat scale = 180.0 / 170.0;
    NSRect rect = (NSRect){.origin = alignmentRect.origin};
    rect.size.width = alignmentRect.size.width * scale;
    rect.size.height = alignmentRect.size.height * scale;
    return rect;
}

- (NSRect)alignmentRectForFrame:(NSRect)frame {
    CGFloat scale = 170.0 / 180.0;
    NSRect rect;
    CGFloat dy = (frame.size.height - 170) / 2.0;
    rect.origin = CGPointMake(frame.origin.x, frame.origin.y + dy);
    rect.size.width = frame.size.width * scale;
    rect.size.height = frame.size.height * scale;
    return rect;
}
#endif

@end
