//
//  RCMediaViewController.m
//  PhotoAndVIdeo
//
//  Created by Roy on 2017/2/28.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "PhotoAndVideo.h"
#import "RCMediaViewController.h"
#import "RCMediaCaptureView.h"

@interface RCMediaViewController ()


@end

@implementation RCMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureView = [[RCMediaCaptureView alloc] initWithFrame:self.view.bounds];
    _captureView.captureDelegate = (id<RCMediaCaptureViewDelegate>)self;
    [self.view addSubview:_captureView];
    
    [_captureView rc_startCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(self.isMovingFromParentViewController)
    {
        [_captureView rc_stopCaptture];
        [_captureView removeFromSuperview];
    }
}

- (void)rc_captureView:(RCMediaCaptureView *)capture didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *PathString;
    if ([[info allKeys] containsObject:@"mediainfo_image"]) {
        UIImage *getImg = [info valueForKey:@"mediainfo_image"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 拼接图片的路径
        PathString = [path stringByAppendingPathComponent:@"photo_tmp.jpg"];
        [UIImageJPEGRepresentation(getImg,1) writeToFile:PathString atomically:YES];
    } else if ([[info allKeys] containsObject:@"mediainfo_video"])  {
        NSURL *url = [info valueForKey:@"mediainfo_video"];
        PathString = url.absoluteString;
    }
    
    [self.plugin capturedImageOrVideoWithPath:PathString];
    
    if([_mediaDelegate respondsToSelector:@selector(rc_mediaController:didFinishPickingMediaWithInfo:)])
    {
        [_mediaDelegate rc_mediaController:self didFinishPickingMediaWithInfo:info];
       
       // NSLog(@"info :r%@",info);
        
    }
    
 [self.plugin dismissCamera];
}

- (void)rc_captureViewDidCancel:(RCMediaCaptureView *)capture
{
    if([_mediaDelegate respondsToSelector:@selector(rc_mediaControlelrDidCancel:)])
    {
        [_mediaDelegate rc_mediaControlelrDidCancel:self];
    }
    
     [self.plugin dismissCamera];
}


#pragma mark--- 屏幕保持全屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait == toInterfaceOrientation;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
