//
//  ImageCutViewController.h
//  BoyueApp
//
//  Created by Embrace on 2017/8/25.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JKImageCutterType) {
    JKImageCutterTypeRounded = 0, /// 圆角框
    JKImageCutterTypeSquare       /// 矩形框
};


//typedef void(^JKImageCutterCompletionHandler)(UIImage * image);

typedef void(^JKImageCutterCompletionHandler)(NSArray * finishArr);

@interface ImageCutViewController : UIViewController

/**
 裁剪框类型：圆形、正方形
 */
@property (nonatomic, assign) JKImageCutterType type;
@property (nonatomic, assign) CGFloat ImgWidth;
@property (nonatomic, assign) CGFloat ImgHeight;


/**
 设置需要裁剪的图片和结果回调，无需担心Block导致循环引用
 
 @param imageSource 需要裁剪的图片
 @param completionHandler 结果回调，返回裁剪后的图片
 */
//- (void)cutImage:(UIImage *)imageSource completionHandler:(JKImageCutterCompletionHandler)completionHandler;

- (void)cutImage:(NSArray *)imageSource completionHandler:(JKImageCutterCompletionHandler)completionHandler;

@end

@interface UINavigationController (JKImageCutter)

@end

