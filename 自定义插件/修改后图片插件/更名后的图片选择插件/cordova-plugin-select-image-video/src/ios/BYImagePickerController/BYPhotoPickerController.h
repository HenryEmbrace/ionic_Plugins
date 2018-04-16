//
//  BYPhotoPickerController.h
//  BoYue
//
//  Created by Embrace on 2017/10/28.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAlbumModel;
@interface BYPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) BYAlbumModel *model;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger photoCount;

@end


@interface BYCollectionView : UICollectionView
@end
