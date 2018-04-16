//
//  VideoPreview.m
//  videodemo
//
//  Created by Embrace on 2017/6/2.
//  Copyright © 2017年 http://navishealth.com. All rights reserved.
//

#import "VideoPreview.h"
#import <AVFoundation/AVFoundation.h>


NSString *const MeidaPlayStatus = @"status";

@interface VideoPreview ()
{
@private
    AVPlayer *_prePlayer;
    AVPlayerItem *_preItem;
    AVPlayerLayer *_preLayer;
}

@end

@implementation VideoPreview
#pragma mark - public method

- (void)previewWithMediaInfo:(MediaInfo *)mediaInfo;
{
    if(!mediaInfo || !mediaInfo.mediaData)
    {
        return;
    }
    
    _mediaInfo = mediaInfo;
    //    self.hidden = YES;
    
    switch(_mediaInfo.mediaType)
    {
        case MediaTypeImage:
        {
            if([_mediaInfo.mediaData isKindOfClass:[UIImage class]])
            {
                self.layer.contentsGravity = kCAGravityResizeAspectFill;
                self.layer.contents = (id)[((UIImage*)_mediaInfo.mediaData) CGImage];
                self.hidden = NO;
            }
        }
            break;
            
        case MediaTypeVideo:
        {
            if([_mediaInfo.mediaData isKindOfClass:[NSURL class]])
            {
                _preItem = [AVPlayerItem playerItemWithURL:_mediaInfo.mediaData];
                _prePlayer = [AVPlayer playerWithPlayerItem:_preItem];
                _preLayer = [AVPlayerLayer playerLayerWithPlayer:_prePlayer];
                _preLayer.frame = [UIScreen mainScreen].bounds;
                
                _preLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.layer addSublayer:_preLayer];
                [self addKVOAndNotifications];
            }
        }
            break;
    }
}

- (void)endPreview
{
    
    switch(_mediaInfo.mediaType)
    {
        case MediaTypeImage:
        {
            self.hidden = YES;
            self.layer.contents = nil;
        }
            break;
            
        case MediaTypeVideo:
        {
            self.hidden = YES;
            [_prePlayer pause];
            [self removeKVOAndNotifications];
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

- (void)addKVOAndNotifications
{
    [_preItem addObserver:self forKeyPath:MeidaPlayStatus options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeKVOAndNotifications
{
    [_preItem removeObserver:self forKeyPath:MeidaPlayStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)didPlayToEnd:(NSNotification *)notify
{
    [_prePlayer seekToTime:CMTimeMakeWithSeconds(0.f, 600) completionHandler:^(BOOL finished) {
        
        [_prePlayer play];
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if([keyPath isEqualToString:MeidaPlayStatus])
    {
        AVPlayerItem *item = (AVPlayerItem*)object;
        switch(item.status)
        {
            case AVPlayerItemStatusReadyToPlay:
            {
                [_prePlayer play];
                self.hidden = NO;
            }break;
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
