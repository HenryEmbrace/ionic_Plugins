//
//  ShowVideoViewController.m
//  test2
//
//  Created by Embrace on 2017/6/1.
//
//

#import "PlayVideo.h"
#import "ShowVideoViewController.h"

@interface ShowVideoViewController ()

@end

@implementation ShowVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setUpSubViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpSubViews {
    _preview = [[VideoPreview alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDisMiss:)];
    [_preview addGestureRecognizer:tap];
    
    
    //        NSString * path = [[NSBundle mainBundle]pathForResource:@"Demo1" ofType:@"mp4"];
//    NSURL * url = [NSURL URLWithString:@"http://boyueimages.shhwec.com/cycle/20170529/20170529-140511201-23.mp4"];
    NSURL * url = [NSURL URLWithString:_UrlStr];

    MediaInfo *mediainfo = [[MediaInfo alloc] init];
    mediainfo.mediaData = url;
    mediainfo.mediaType = MediaTypeVideo;
    
    [_preview previewWithMediaInfo:mediainfo];
    [self.view addSubview:_preview];
    
}

- (void)tapToDisMiss:(UITapGestureRecognizer *)gestureOut {
    [_preview endPreview];
//    NSLog(@"轻拍了一下");
    [self.plugin dismissViewController];
}
@end


@implementation MediaInfo

- (void)dealloc
{
    NSLog(@"\n%s", __FUNCTION__);
}

+ (NSString *)mediaTypeString:(MediaType)type
{
    NSString *result = @"Unknown";
    switch(type)
    {
        case MediaTypeVideo:
        {
            result = @"MediaTypeVideo";
        }
            break;
            
        case MediaTypeImage:
        {
            result = @"MediaTypeImage";
        }
            break;
    }
    
    return result;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, RCMediaType: %@, RCMediaData: %@>", NSStringFromClass(self.class), self, [self.class mediaTypeString:self.mediaType], [self.mediaData description]];
}

@end
