//
//  WebViewLoad.h
//  test5
//
//  Created by Embrace on 2017/6/12.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "WebViewController.h"



@interface WebViewLoad : CDVPlugin
-(void)LoadWeb:(CDVInvokedUrlCommand *)command;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic,strong) WebViewController *webVC;
-(void) dismissController;

@end
