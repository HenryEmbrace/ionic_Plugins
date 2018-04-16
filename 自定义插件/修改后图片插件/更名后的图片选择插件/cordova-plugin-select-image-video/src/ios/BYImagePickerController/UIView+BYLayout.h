//
//  UIView+BYLayout.h
//  BoYue
//
//  Created by Embrace on 2017/10/28.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BYOscillatoryAnimationToBigger,
    BYOscillatoryAnimationToSmaller,
} BYOscillatoryAnimationType;


@interface UIView (BYLayout)

    @property (nonatomic) CGFloat BY_left;        ///< Shortcut for frame.origin.x.
    @property (nonatomic) CGFloat BY_top;         ///< Shortcut for frame.origin.y
    @property (nonatomic) CGFloat BY_right;       ///< Shortcut for frame.origin.x + frame.size.width
    @property (nonatomic) CGFloat BY_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
    @property (nonatomic) CGFloat BY_width;       ///< Shortcut for frame.size.width.
    @property (nonatomic) CGFloat BY_height;      ///< Shortcut for frame.size.height.
    @property (nonatomic) CGFloat BY_centerX;     ///< Shortcut for center.x
    @property (nonatomic) CGFloat BY_centerY;     ///< Shortcut for center.y
    @property (nonatomic) CGPoint BY_origin;      ///< Shortcut for frame.origin.
    @property (nonatomic) CGSize  BY_size;        ///< Shortcut for frame.size.
    
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(BYOscillatoryAnimationType)type;
    
@end
