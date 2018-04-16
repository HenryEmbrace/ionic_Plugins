//
//  PhotoAndVideo.h
//  test5
//
//  Created by Embrace on 2017/6/1.
//
//

#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import "RCMediaViewController.h"

@interface PhotoAndVideo : CDVPlugin
-(void) getVideosAndImage:(CDVInvokedUrlCommand *)command;
-(void) getImage:(CDVInvokedUrlCommand *)command;
-(void) getVideos:(CDVInvokedUrlCommand *)command;

-(void) capturedImageOrVideoWithPath:(NSString*)GetPath;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic,strong) RCMediaViewController *mediaVC;
-(void) dismissCamera;

@end
