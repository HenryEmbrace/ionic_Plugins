//
//  UIView+BYLayout.m
//  BoYue
//
//  Created by Embrace on 2017/10/28.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import "UIView+BYLayout.h"

@implementation UIView (BYLayout)

- (CGFloat)BY_left {
    return self.frame.origin.x;
}
    
- (void)setBY_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
    
- (CGFloat)BY_top {
    return self.frame.origin.y;
}
    
- (void)setBY_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
    
- (CGFloat)BY_right {
    return self.frame.origin.x + self.frame.size.width;
}
    
- (void)setBY_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
    
- (CGFloat)BY_bottom {
    return self.frame.origin.y + self.frame.size.height;
}
    
- (void)setBY_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
    
- (CGFloat)BY_width {
    return self.frame.size.width;
}
    
- (void)setBY_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
    
- (CGFloat)BY_height {
    return self.frame.size.height;
}
    
- (void)setBY_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
    
- (CGFloat)BY_centerX {
    return self.center.x;
}
    
- (void)setBY_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
    
- (CGFloat)BY_centerY {
    return self.center.y;
}
    
- (void)setBY_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
    
- (CGPoint)BY_origin {
    return self.frame.origin;
}
    
- (void)setBY_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
    
- (CGSize)BY_size {
    return self.frame.size;
}
    
- (void)setBY_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
    
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(BYOscillatoryAnimationType)type{
    NSNumber *animationScale1 = type == BYOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == BYOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}
    
@end
