//
//  PlayVideo.m
//  test7
//
//  Created by Embrace on 2017/6/2.
//
//

#import "PlayVideo.h"
#define HttpUrl @"http://boyueimages.shhwec.com/"
@implementation PlayVideo
- (void)playVideoMethod:(CDVInvokedUrlCommand *)command {
     NSString *url = [NSString stringWithFormat:@"%@%@",HttpUrl,[command.arguments lastObject]];
    self.hasPendingOperation = YES;
    __weak PlayVideo* weakSelf = self;
    weakSelf.mediaVC = [[ShowVideoViewController alloc] init];
    
    weakSelf.mediaVC.plugin = self;
    weakSelf.mediaVC.UrlStr = url;
    [self.viewController presentViewController:weakSelf.mediaVC animated:YES completion:nil];
}



-(void)dismissViewController {
    __weak PlayVideo* weakSelf = self;
    weakSelf.mediaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [weakSelf.mediaVC dismissViewControllerAnimated:YES completion:nil];
}
@end
