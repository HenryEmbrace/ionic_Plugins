#import "ShareSDKPlugin.h"
#import <Cordova/CDVPlugin.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>


@implementation ShareSDKPlugin

- (void)share:(CDVInvokedUrlCommand*)command {
    
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* text = [command.arguments objectAtIndex:1];
    NSString* imageUrl = [command.arguments objectAtIndex:2];
    NSString* url = [command.arguments objectAtIndex:3];

    // CDVPluginResult* __block pluginResult = nil;
     //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content: text
//                                       defaultContent: text
//                                                image:[ShareSDK imageWithUrl:imageUrl]
//                                                title: title
//                                                  url: url
//                                          description: text
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imageArray
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    
    
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    

    //弹出分享菜单
//    [ShareSDK showShareActionSheet:nil
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                CDVPluginResult* pluginResult = nil;
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
//                                    
//                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
//                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]]];
//                                    
//                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                                }
//                                else if (state == SSResponseStateCancel)
//                                {
//                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancel"];
//                                    
//                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                                }
//                            }];
    
    
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
                           //
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]]];
                           //
                         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
                       }
                       default:
                           break;
                   }
               }
     ];
    
    


}


- (void)handleOpenURL:(NSNotification*)notification
{
    // override to handle urls sent to your app
    // register your url schemes in your App-Info.plist
    NSURL* url = [notification object];
    if ([url isKindOfClass:[NSURL class]]) {
        /* Do your thing! */
        NSLog([NSString stringWithFormat:@"%@", url]);
        [ShareSDK handleOpenURL:url wxDelegate:self];
    }
}

@end

