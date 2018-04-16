//
//  HiddenTabBar.m
//  BoYue
//
//  Created by Embrace on 2017/8/3.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import "HiddenTabBar.h"

@implementation HiddenTabBar


-(void) hideTab:(CDVInvokedUrlCommand *)command {
    
    NSLog(@"you selected hideTab");
    __weak HiddenTabBar * weakSelf = self;
    weakSelf.viewController.tabBarController.tabBar.hidden = YES;
    
}

-(void) showTab:(CDVInvokedUrlCommand *)command {
    
    NSLog(@"you selected showTab");
    __weak HiddenTabBar * weakSelf = self;
    weakSelf.viewController.tabBarController.tabBar.hidden = NO;
    
}

@end
