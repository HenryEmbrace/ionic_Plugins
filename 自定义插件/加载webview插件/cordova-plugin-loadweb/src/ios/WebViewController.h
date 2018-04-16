//
//  WebViewController.h
//  WebViewDemo
//
//  Created by Embrace on 2017/6/12.
//
//

#import <UIKit/UIKit.h>
@class WebViewLoad;
@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, strong) WebViewLoad *plugin;
@property (nonatomic,copy) NSString *UrlStr;

@end
