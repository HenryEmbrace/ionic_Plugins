//
//  PhotoAndVideo.m
//  test5
//
//  Created by Embrace on 2017/6/1.
//
//

#import "PhotoAndVideo.h"

@implementation PhotoAndVideo
- (void)getVideosAndImage:(CDVInvokedUrlCommand *)command {
    self.hasPendingOperation = YES;
    __weak PhotoAndVideo* weakSelf = self;
    
    NSString *activeteStr = @"照片或视频";
    weakSelf.latestCommand = command;
    weakSelf.mediaVC = [[RCMediaViewController alloc] init];
    weakSelf.mediaVC.actiStr = activeteStr;
    
    
    weakSelf.mediaVC.plugin = self;
    [self.viewController presentViewController:weakSelf.mediaVC animated:YES completion:nil];
}


-(void) getImage:(CDVInvokedUrlCommand *)command {
    self.hasPendingOperation = YES;
    __weak PhotoAndVideo* weakSelf = self;
    
    NSString *activeteStr = @"照片";
    weakSelf.latestCommand = command;
    weakSelf.mediaVC = [[RCMediaViewController alloc] init];
    weakSelf.mediaVC.actiStr = activeteStr;
    
    
    weakSelf.mediaVC.plugin = self;
    [self.viewController presentViewController:weakSelf.mediaVC animated:YES completion:nil];
}

-(void) getVideos:(CDVInvokedUrlCommand *)command {
    self.hasPendingOperation = YES;
    __weak PhotoAndVideo* weakSelf = self;
    
    NSString *activeteStr = @"视频";
    weakSelf.latestCommand = command;
    weakSelf.mediaVC = [[RCMediaViewController alloc] init];
    weakSelf.mediaVC.actiStr = activeteStr;
    
    
    weakSelf.mediaVC.plugin = self;
    [self.viewController presentViewController:weakSelf.mediaVC animated:YES completion:nil];
}


-(void)dismissCamera {
    __weak PhotoAndVideo* weakSelf = self;
    [weakSelf.mediaVC dismissViewControllerAnimated:YES completion:nil];
}

-(void) capturedImageOrVideoWithPath:(NSString*)GetPath {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:GetPath] callbackId:self.latestCommand.callbackId];
    // Unset the self.hasPendingOperation property
    self.hasPendingOperation = NO;
    
    // Hide the picker view
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
