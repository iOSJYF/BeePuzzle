//
//  BeeSlicingViewController.h
//  BeePuzzle
//
//  Created by Ji_YuFeng on 16/12/29.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeeBaseNavigationViewController.h"

@interface BeeSlicingViewController : BeeBaseNavigationViewController

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)int colums;
@property (nonatomic,assign)int rows;
//@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIImage *image;

@end
