//
//  BYAssetModel.m
//  BoYue
//
//  Created by Embrace on 2017/10/27.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import "BYAssetModel.h"
#import "BYImageManager.h"

@implementation BYAssetModel
    
+ (instancetype)modelWithAsset:(id)asset type:(BYAssetModelMediaType)type{
    BYAssetModel *model = [[BYAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}
    
+ (instancetype)modelWithAsset:(id)asset type:(BYAssetModelMediaType)type timeLength:(NSString *)timeLength {
    BYAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}
@end


@implementation BYAlbumModel

- (void)setResult:(id)result {
        _result = result;
        BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BY_allowPickingImage"] isEqualToString:@"1"];
        BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BY_allowPickingVideo"] isEqualToString:@"1"];
        [[BYImageManager manager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<BYAssetModel *> *models) {
            _models = models;
            if (_selectedModels) {
                [self checkSelectedModels];
            }
        }];
    }
    
- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}
    
- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (BYAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (BYAssetModel *model in _models) {
        if ([[BYImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount ++;
        }
    }
}
    
- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}
@end
