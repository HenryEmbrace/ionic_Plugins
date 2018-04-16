//
//  VideoPreview.h
//  videodemo
//
//  Created by Embrace on 2017/6/2.
//  Copyright © 2017年 http://navishealth.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MediaType)
{
    ///image instance
    MediaTypeImage = 1,
    ///NSURL instance
    MediaTypeVideo
};

@interface MediaInfo : NSObject

@property (nonatomic, strong) id mediaData;

@property (nonatomic, assign) MediaType mediaType;

@end
@interface VideoPreview : UIView
@property (nonatomic, readonly)MediaInfo *mediaInfo;

- (void)previewWithMediaInfo:(MediaInfo *)mediaInfo;

- (void)endPreview;
@end
