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
    NSError *error;
    NSString*appid = @"1196639787";
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appid]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    //    NSLog(@"%@",appInfoDic);
    NSArray *array = appInfoDic[@"results"];
    
    if (array.count < 1) {
        NSLog(@"此APPID为未上架的APP或者查询不到");
        return;
    }
    
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    //3打印版本号
        NSLog(@"商店版本号:%@",appStoreVersion);
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:appStoreVersion] callbackId:self.latestCommand.callbackId];
}
    
   
@end
