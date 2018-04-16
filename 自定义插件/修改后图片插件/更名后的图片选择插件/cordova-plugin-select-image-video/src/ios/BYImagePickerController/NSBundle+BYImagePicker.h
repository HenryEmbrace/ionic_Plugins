//
//  NSBundle+BYImagePicker.h
//  BoYue
//
//  Created by Embrace on 2017/10/27.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (BYImagePicker)
+ (NSBundle *)BY_imagePickerBundle;
    
+ (NSString *)BY_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)BY_localizedStringForKey:(NSString *)key;
@end
