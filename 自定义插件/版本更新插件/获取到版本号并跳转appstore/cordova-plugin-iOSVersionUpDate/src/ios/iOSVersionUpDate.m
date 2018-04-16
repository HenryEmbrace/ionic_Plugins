//
//  iOSVersionUpDate.m
//  test6
//
//  Created by Embrace on 2017/10/23.
//

#import "iOSVersionUpDate.h"

@implementation iOSVersionUpDate
-(void)checkUpVersion:(CDVInvokedUrlCommand*)command {
    __weak __typeof(&*self)weakSelf = self;
    weakSelf.latestCommand = command;
    NSString *currVersion = [NSString stringWithFormat:@"%@",[command.arguments lastObject]];
    [HSUpdateApp hs_updateWithAPPID:@"1196639787" currentVersion:currVersion block:^(NSString *currentVersion,NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        _StoreCurrentVersion= storeVersion;
        if (isUpdate == YES) {
            [weakSelf showStoreVersion:storeVersion openUrl:openUrl];
        }
    }];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:_StoreCurrentVersion] callbackId:self.latestCommand.callbackId];
}
    
-(void)showStoreVersion:(NSString *)storeVersion openUrl:(NSString *)openUrl{
    UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",storeVersion] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:openUrl];
        [[UIApplication sharedApplication] openURL:url];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alercConteoller addAction:actionYes];
    [alercConteoller addAction:actionNo];
    [self.viewController presentViewController:alercConteoller animated:YES completion:nil];
}
    
    @end

