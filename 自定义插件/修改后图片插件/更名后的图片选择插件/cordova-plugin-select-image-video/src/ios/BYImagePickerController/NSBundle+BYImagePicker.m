//
//  NSBundle+BYImagePicker.m
//  BoYue
//
//  Created by Embrace on 2017/10/27.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import "NSBundle+BYImagePicker.h"
#import "BYImagePickerController.h"
@implementation NSBundle (BYImagePicker)

+ (NSBundle *)BY_imagePickerBundle {
        NSBundle *bundle = [NSBundle bundleForClass:[BYImagePickerController class]];
        NSURL *url = [bundle URLForResource:@"BYImagePickerController" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
        return bundle;
    }
    
+ (NSString *)BY_localizedStringForKey:(NSString *)key {
    return [self BY_localizedStringForKey:key value:@""];
}
    
+ (NSString *)BY_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle BY_imagePickerBundle] pathForResource:language ofType:@"lproj"]];
    }
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}
@end
