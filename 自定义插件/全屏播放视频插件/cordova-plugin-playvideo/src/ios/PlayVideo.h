//
//  PlayVideo.h
//  test7
//
//  Created by Embrace on 2017/6/2.
//
//


#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import "ShowVideoViewController.h"
@interface PlayVideo : CDVPlugin
-(void) playVideoMethod:(CDVInvokedUrlCommand *)command;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic,strong) ShowVideoViewController *mediaVC;
-(void) dismissViewController;

@end
