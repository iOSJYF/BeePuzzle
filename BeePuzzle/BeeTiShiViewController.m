//
//  BeeTiShiViewController.m
//  BeePuzzle
//
//  Created by Ji_YuFeng on 2017/6/15.
//  Copyright © 2017年 蜜蜂. All rights reserved.
//

#import "BeeTiShiViewController.h"

@interface BeeTiShiViewController ()

@end

@implementation BeeTiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *successImg = [UIImageView new];
    [successImg setImage:self.theImage];
    [self.view addSubview:successImg];
    [successImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@114);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(successImg.mas_width);
    }];
    
    
    WS(weakSelf);
    [self.view whenTapped:^{
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.subtype = kCATransitionMoveIn;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
