//
//  ShowGetImgArrCell.m
//  BoyueApp
//
//  Created by Embrace on 2017/8/25.
//
//

#import "ShowGetImgArrCell.h"

@implementation ShowGetImgArrCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

-(UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
    }
    return _imgView;
}

@end
