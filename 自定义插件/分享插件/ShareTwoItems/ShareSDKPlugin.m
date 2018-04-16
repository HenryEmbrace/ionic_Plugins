#import "ShareSDKPlugin.h"
#import <Cordova/CDVPlugin.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

//#import <MOBFoundation/MOBFoundation.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博
#import "WeiboSDK.h"
#define Start_X 20.0f           // 第一个按钮的X坐标
#define Width_Space 3.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距

// 获取屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHight [UIScreen mainScreen].bounds.size.height
// 适配
#define DevicesScale ([UIScreen mainScreen].bounds.size.height==480?1.00:[UIScreen mainScreen].bounds.size.height==568?1.00:[UIScreen mainScreen].bounds.size.height==667?1.17:1.29)

// 颜色
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




// 设备类型
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f




@implementation ShareSDKPlugin
static id _publishContent;//类方法中的全局变量这样用（类型前面加static）
static UIVisualEffectView *_effectView;
static UIView *blackView;
- (void)pluginInitialize {
    //    [self setShareView];
    NSString* sharesdkAppKey = [[self.commandDelegate settings] objectForKey:@"sharesdkappkey"];
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* qqAppId = [[self.commandDelegate settings] objectForKey:@"qqappid"];
    NSString* qqAppKey = [[self.commandDelegate settings] objectForKey:@"qqappkey"];
    NSString* wbAppKey = [[self.commandDelegate settings] objectForKey:@"wbappkey"];
    NSString* wbAppSecret = [[self.commandDelegate settings] objectForKey:@"wbappsecret"];
    NSString* wbRedirectUrl = [[self.commandDelegate settings] objectForKey:@"wbredirecturl"];
    
    if(wechatAppId && wechatAppSecret && qqAppId && qqAppKey && wbAppKey && wbAppSecret && wbRedirectUrl && sharesdkAppKey){
        
        
        [ShareSDK registerApp:sharesdkAppKey
         
              activePlatforms:@[ @(SSDKPlatformTypeQQ),
                                 @(SSDKPlatformTypeWechat),
                                 @(SSDKPlatformTypeSinaWeibo)]
                     onImport:^(SSDKPlatformType platformType)
         {
             switch (platformType)
             {
                 case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                 case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                 case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                 default:{
                     
                 }
                     break;
             }
         }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
         {
             
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:wbAppKey
                                               appSecret:wbAppSecret
                                             redirectUri:wbRedirectUrl
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:wechatAppId
                                           appSecret:wechatAppSecret];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:qqAppId
                                          appKey:qqAppKey
                                        authType:SSDKAuthTypeBoth];
                     break;
                 default:
                     break;
             }
         }];
        
    }
}

- (void)share:(CDVInvokedUrlCommand*)command {
    
    
    self.hasPendingOperation = YES;
    __weak ShareSDKPlugin* weakSelf = self;
    weakSelf.latestCommand = command;
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* text = [command.arguments objectAtIndex:1];
    NSString* imageUrl = [command.arguments objectAtIndex:2];
    NSString* url = [command.arguments objectAtIndex:3];
    
    NSArray* imageArray = @[imageUrl];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:text
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //调用自定义分享
        [self shareWithContent:shareParams];
        
    }
    
}


- (void)handleOpenURL:(NSNotification*)notification
{
    // override to handle urls sent to your app
    // register your url schemes in your App-Info.plist
    NSURL* url = [notification object];
    if ([url isKindOfClass:[NSURL class]]) {
        /* Do your thing! */
        NSLog(@"%@", [NSString stringWithFormat:@"%@", url]);
    }
}


#pragma mark --- Custom ShareSDK UI
/*
 自定义的分享类， 构造分享内容publishContent就行了
 */

-(void)shareWithContent:(id)publishContent/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    _publishContent = publishContent;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat bt_width =  75 * DevicesScale;
    if(kScreenHight == 568) {
        bt_width = 85 *DevicesScale;
    }
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    _effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHight);
    _effectView.alpha = 0.2;
    [window addSubview:_effectView];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHight - bt_width), kScreenWidth, bt_width)];
    blackView.backgroundColor = [UIColor whiteColor];
    //    blackV.alpha = 0.2;
    [window addSubview:blackView];
    
    
    
    /**
     点击退出手势
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_effectView addGestureRecognizer:tap];
    
    
    /**
     Share Content
     */
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0,(kScreenHight - bt_width - 10)  ,kScreenWidth,bt_width)];
    
    shareView.tag = 441;
    [window addSubview:shareView];
    NSArray *btnImages = @[ @"sns_icon_22@2x", @"sns_icon_23@2x",@"sns_icon_37@2x"];
    NSArray *btnTitles = @[ @"微信好友", @"朋友圈",@"微信收藏"];
    
    for (NSInteger i=0; i<btnImages.count; i++) {
        NSInteger index = i % 3;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index * (kScreenWidth / 3) , 0, kScreenWidth / 3, bt_width)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor lightGrayColor])];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, bt_width - 20, kScreenWidth / 3, 20)];
        lbl.font = [UIFont systemFontOfSize:12*DevicesScale];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = UIColorFromRGB(0x374552);
        lbl.text = btnTitles[i];
        [button addSubview:lbl];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 + 1, 15, 0.5, bt_width - 20)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [button addSubview:lineView];
        
        
        
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
    
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    _effectView.contentView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1, 1);
        _effectView.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)shareBtnClick:(UIButton *)btn
{
    
    int shareType = 0;
    id publishContent = _publishContent;
    
    switch (btn.tag) {
        case 331:
        {
            //            shareType = SSDKPlatformSubTypeQQFriend;
            shareType = SSDKPlatformSubTypeWechatSession;
            
        }
            break;
            
        case 332:
        {
            //            shareType = SSDKPlatformSubTypeWechatSession;
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case 333:
        {
            //            shareType = SSDKPlatformSubTypeWechatSession;
            shareType = SSDKPlatformSubTypeWechatFav;
        }
            break;
            
            
        default:
            break;
    }
    
    /*
     调用shareSDK的无UI分享类型，
     */
    
    [ShareSDK share:shareType parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        CDVPluginResult* pluginResult = nil;
        NSString *platform;
        if (state == SSDKResponseStateSuccess)
        {
            
            switch (shareType) {
                    
                case 22:
                {
                    platform = @"Wechat";
                    
                }
                    break;
                    
                case 23:
                {
                    platform = @"WechatMoments";
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Success | %@",platform]];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.latestCommand.callbackId];
            
            [self dismiss];
        }
        else if (state == SSDKResponseStateFail)
        {
            NSLog(@"分享失败,错误描述:%@", error );
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"错误描述:%@",error ]];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.latestCommand.callbackId];
        }
        else if (state == SSDKResponseStateCancel)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancel"];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.latestCommand.callbackId];
        }
    }];
    
}

- (void)dismiss {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *shareView = [window viewWithTag:441];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        _effectView.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [_effectView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
}

@end

