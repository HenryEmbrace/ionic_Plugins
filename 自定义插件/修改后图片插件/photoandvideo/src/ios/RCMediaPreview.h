//
//  RCMediaPreview.h
//  PhotoAndVIdeo
//
//  Created by Roy on 2017/3/5.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
///media data type enum
typedef NS_ENUM(NSInteger, RCMediaType)
{
    ///image instance
    RCMediaTypeImage = 1,
    ///NSURL instance
    RCMediaTypeVideo
};

@interface RCMediaInfo : NSObject

@property (nonatomic, strong) id mediaData;

@property (nonatomic, assign) RCMediaType mediaType;

@end

@interface RCMediaPreview : UIView

@property (nonatomic, readonly) RCMediaInfo *mediaInfo;
- (void)rc_previewWithMediaInfo:(RCMediaInfo *)mediaInfo;
@property (nonatomic, strong) AVPlayer *prePlayer;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer  * previewLayer;
@property (nonatomic, strong)AVPlayerLayer *preLayer;
@property (nonatomic, strong) UIView *showVideoView;

- (void)rc_endPreview;

@end
