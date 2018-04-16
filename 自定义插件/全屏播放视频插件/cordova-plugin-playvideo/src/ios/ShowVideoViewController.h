//
//  ShowVideoViewController.h
//  test2
//
//  Created by Embrace on 2017/6/1.
//
//

#import <UIKit/UIKit.h>
#import "VideoPreview.h"
@class ShowVideoViewController;
@class PlayVideo;
@interface ShowVideoViewController : UIViewController
@property (nonatomic,strong)  VideoPreview *preview;
@property (nonatomic,strong) PlayVideo *plugin;
@property (nonatomic,copy) NSString *UrlStr;
@end
