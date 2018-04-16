//
//  RCMediaPreview.m
//  PhotoAndVIdeo
//
//  Created by Roy on 2017/3/5.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "RCMediaPreview.h"
#import "Masonry.h"
#import "MotionOrientation.h"
#define kScreenSize UIScreen.mainScreen.bounds.size
#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height
//#import <AVFoundation/AVFoundation.h>

NSString *const RCMeidaPlayStatus = @"status";

@interface RCMediaPreview ()
{
@private
    //    AVPlayer *_prePlayer;
    AVPlayerItem *_preItem;
    //    AVPlayerLayer *_preLayer;
    
}

@end

@implementation RCMediaPreview

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupShowVideoView];
    }
    return self;
    
}

-(void)setupShowVideoView {
    _showVideoView = [[UIView alloc] init];
    [self addSubview:_showVideoView];
    [_showVideoView setBackgroundColor:[UIColor clearColor]];
    [_showVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(kScreenHeight));
    }];
    
    //    [_showImgView setHidden:YES];
}



#pragma mark - public method

- (void)rc_previewWithMediaInfo:(RCMediaInfo *)mediaInfo;
{
    if(!mediaInfo || !mediaInfo.mediaData)
    {
        return;
    }
    
    _mediaInfo = mediaInfo;
    self.hidden = YES;
    
    switch(_mediaInfo.mediaType)
    {
        case RCMediaTypeImage:
        {
            
            if([_mediaInfo.mediaData isKindOfClass:[UIImage class]])
            {
                
                
                
                //                self.layer.contentsGravity = kCAGravityResizeAspect;
                //                self.layer.contents = (id)[((UIImage*)_mediaInfo.mediaData) CGImage];
                //                self.hidden = NO;
                
                self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]init];
                self.previewLayer.contents= (id)[((UIImage*)_mediaInfo.mediaData) CGImage];
                [ self.layer setMasksToBounds:YES];
                
                
                
                
                
                
                CGRect bounds = [self bounds];
                //                [previewLayer setFrame:bounds];
                [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
                
                [self.layer insertSublayer:self.previewLayer below:[[self.layer sublayers] objectAtIndex:0]];
                
                
            }
        }
        break;
        
        case RCMediaTypeVideo:
        {
            if([_mediaInfo.mediaData isKindOfClass:[NSURL class]])
            {
                
                _preItem = [AVPlayerItem playerItemWithURL:_mediaInfo.mediaData];
                _prePlayer = [AVPlayer playerWithPlayerItem:_preItem];
                _preLayer = [AVPlayerLayer playerLayerWithPlayer:_prePlayer];
                //                _preLayer.frame = _showVideoView.frame;
                _preLayer.frame = self.bounds;
                
                long optionInt = (long)[MotionOrientation sharedInstance].deviceOrientation;
                
                int   opInt = (int)optionInt;
                
                if (opInt == 1) {
                    
                    _preLayer.frame = _showVideoView.frame;
                    
                }
                
                if (opInt == 2) {
                    
                    _preLayer.frame = _showVideoView.frame;
                    
                }
                if (opInt == 3) {
                    _preLayer.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200);
                    ;
                    
                    
                }
                if (opInt == 4) {
                    _preLayer.frame =  _preLayer.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200);
                    
                }
                
                
                _preLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.layer addSublayer:_preLayer];
                
                //                [ self.layer setMasksToBounds:YES];
                
                
                
                //                CGRect bounds = [self bounds];
                //                [_preLayer setFrame:bounds];
                //                [_preLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                //
                //                [self.layer insertSublayer:_preLayer below:[[self.layer sublayers] objectAtIndex:0]];
                
                
                [self rc_addKVOAndNotifications];
                
                
                
                
                
                
                
                
                
                
            }
        }
        break;
    }
}

- (void)rc_endPreview
{
    
    switch(_mediaInfo.mediaType)
    {
        case RCMediaTypeImage:
        {
            self.hidden = YES;
            self.layer.contents = nil;
        }
        break;
        
        case RCMediaTypeVideo:
        {
            self.hidden = YES;
            [_prePlayer pause];
            [self rc_removeKVOAndNotifications];
            [_preLayer removeFromSuperlayer];
            _preLayer = nil;
            _preItem = nil;
            _prePlayer = nil;
        }
        break;
    }
    
    _mediaInfo = nil;
}

#pragma mark - kvo and notifications

- (void)rc_addKVOAndNotifications
{
    [_preItem addObserver:self forKeyPath:RCMeidaPlayStatus options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rc_didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)rc_removeKVOAndNotifications
{
    [_preItem removeObserver:self forKeyPath:RCMeidaPlayStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)rc_didPlayToEnd:(NSNotification *)notify
{
    [_prePlayer seekToTime:CMTimeMakeWithSeconds(0.f, 600) completionHandler:^(BOOL finished) {
        
        [_prePlayer play];
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if([keyPath isEqualToString:RCMeidaPlayStatus])
    {
        AVPlayerItem *item = (AVPlayerItem*)object;
        switch(item.status)
        {
            case AVPlayerItemStatusReadyToPlay:
            {
                [_prePlayer play];
                self.hidden = NO;
            }
            break;
            default:NSLog(@"\nCan not play for url: %@.", _mediaInfo.mediaData);break;
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
