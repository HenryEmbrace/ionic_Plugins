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
-(void) takePhotoOrVideoMethod:(CDVInvokedUrlCommand *)command;
-(void) capturedImageOrVideoWithPath:(NSString*)GetPath;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic,strong) RCMediaViewController *mediaVC;
-(void) dismissCamera;

@end
