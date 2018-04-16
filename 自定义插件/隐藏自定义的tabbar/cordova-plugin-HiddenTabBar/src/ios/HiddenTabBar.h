//
//  HiddenTabBar.h
//  BoYue
//
//  Created by Embrace on 2017/8/3.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface HiddenTabBar : CDVPlugin

-(void) hideTab:(CDVInvokedUrlCommand *)command;
-(void) showTab:(CDVInvokedUrlCommand *)command;

@end
