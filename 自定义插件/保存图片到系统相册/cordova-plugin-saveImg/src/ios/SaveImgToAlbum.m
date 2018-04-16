//
//  SaveImgToAlbum.m
//  saveImgDemo
//
//  Created by Embrace on 2017/7/3.
//
//

#import "SaveImgToAlbum.h"

@implementation SaveImgToAlbum
-(void)saveImgMothed:(CDVInvokedUrlCommand *)command {
    
    //    NSString *urlString = @"https://github.com/CJT2325/CameraView/raw/master/assets/screenshot_0.jpg";
    
    NSString *urlString =  [NSString stringWithFormat:@"%@",[command.arguments lastObject]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    UIImage *image1 = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image1, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        NSLog(@"save success");
        
        
        
    }else{
        NSLog(@"save failed");
    }
}


@end
