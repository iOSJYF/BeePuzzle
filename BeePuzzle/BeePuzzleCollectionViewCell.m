//
//  BeePuzzleCollectionViewCell.m
//  BeePuzzle
//
//  Created by Ji_YuFeng on 16/12/27.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "BeePuzzleCollectionViewCell.h"
#import <Masonry.h>

@implementation BeePuzzleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _candyImage = [[UIImageView alloc]init];
        [self addSubview:_candyImage];
        [_candyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
        
    }
    return self;
}

@end
