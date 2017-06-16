//
//  BeeShowPicViewController.m
//  BeePuzzle
//
//  Created by Ji_YuFeng on 2017/6/15.
//  Copyright © 2017年 蜜蜂. All rights reserved.
//

#import "BeeShowPicViewController.h"
#import <UIImage+GIF.h>

@interface BeeShowPicViewController ()

@property (nonatomic,strong)UIImageView *tiaotiaoImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *runImg;
@property (nonatomic,strong)UILabel *keepMoving;

@end

@implementation BeeShowPicViewController

- (UILabel *)keepMoving
{
    if (!_keepMoving) {
        _keepMoving = [[UILabel alloc]init];
        _keepMoving.text = @"Keep Going ~!";
    }
    return _keepMoving;
}

- (UIImageView *)runImg
{
    if (!_runImg) {
        _runImg = [[UIImageView alloc]init];
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"huochairen.gif" ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        _runImg.image = [UIImage sd_animatedGIFWithData:imageData];
    }
    return _runImg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"恭喜你 挑战成功";
    }
    return _titleLabel;
}

- (UIImageView *)tiaotiaoImageView
{
    if (!_tiaotiaoImageView) {
        _tiaotiaoImageView = [[UIImageView alloc]init];
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"tiaotiao.gif" ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        _tiaotiaoImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    }
    return _tiaotiaoImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [successImg whenTapped:^{
        CATransition *animation = [CATransition animation];
        animation.duration = 2;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        //animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFade;
        [weakSelf.view.window.layer addAnimation:animation forKey:nil];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    
    
    
    [self.view addSubview:self.tiaotiaoImageView];
    [self.tiaotiaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.height.equalTo(@80);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(self.tiaotiaoImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.tiaotiaoImageView);
    }];
    
    
//    [self.view addSubview:self.keepMoving];
//    [self.keepMoving mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(successImg.mas_bottom).offset(60);
//        make.left.mas_equalTo(10);
//    }];
    
    
    [self.view addSubview:self.runImg];
    self.runImg.frame = CGRectMake(-100, ScreenWidth+100, 250, 140);
    
    [self performSelector:@selector(dosomething) withObject:nil afterDelay:1];
    
    
    

    
}

- (void)dosomething
{
    [UIView animateWithDuration:10 animations:^{
        self.runImg.frame = CGRectMake(ScreenWidth-180, ScreenWidth+100, 250, 140);
    }];
    
    
    
}



@end
