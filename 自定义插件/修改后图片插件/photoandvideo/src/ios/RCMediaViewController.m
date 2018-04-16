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

#define kScreenSize UIScreen.mainScreen.bounds.size
#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height
@interface RCMediaViewController ()


@end

@implementation RCMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _captureView = [[RCMediaCaptureView alloc] initWithFrame:self.view.bounds];
    _captureView.toolbar.acStr = self.actiStr;
    _captureView.captureDelegate = (id<RCMediaCaptureViewDelegate>)self;
    [self.view addSubview:_captureView];

    [_captureView rc_startCapture];
}

#pragma mark --- 屏幕旋转适配
-(void)viewWillLayoutSubviews {
    _captureView.frame = self.view.frame;
    _captureView.showImgView.frame = self.view.frame;
    _captureView.captureLayer.frame = self.view.frame;
    _captureView.preview.showVideoView.frame = self.view.frame;
    _captureView.preview.showVideoView.center = self.view.center;
    _captureView.preview.previewLayer.frame = self.view.frame;
    
    _captureView.preview.preLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _captureView.toolbar.frame = CGRectMake(0, kScreenHeight - 100, kScreenWidth, 80);
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
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];

        PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[formater stringFromDate:[NSDate date]]]];

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

#pragma mark --- 禁止拍照或者摄像时旋转
//是否可以旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
