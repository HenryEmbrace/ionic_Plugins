//
//  WebViewLoad.m
//  test5
//
//  Created by Embrace on 2017/6/12.
//
//

#import "WebViewLoad.h"

@implementation WebViewLoad
-(void)LoadWeb:(CDVInvokedUrlCommand *)command {
    
    NSString *url = [command.arguments lastObject];
    self.hasPendingOperation = YES;
    self.hasPendingOperation = YES;
    __weak WebViewLoad *weakSelf = self;
    
    weakSelf.latestCommand = command;
    weakSelf.webVC = [[WebViewController alloc] init];
    weakSelf.webVC.plugin = self;
    weakSelf.webVC.UrlStr = url;
    [self.viewController presentViewController:weakSelf.webVC animated:YES completion:nil];
}

-(void)dismissController {
    __weak WebViewLoad *weakSelf = self;
    [weakSelf.webVC dismissViewControllerAnimated:YES completion:nil];
}





@end
