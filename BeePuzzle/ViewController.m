//
//  ViewController.m
//  BeePuzzle
//
//  Created by Ji_YuFeng on 16/12/23.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "BeeSlicingViewController.h"
#import <UIImage+GIF.h>

#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width

#define RGB_yellow [UIColor colorWithRed:222/255.0 green:90/255.0 blue:30/255.0 alpha:1.0]
#define RGB_red [UIColor colorWithRed:165/255.0 green:0/255.0 blue:26/255.0 alpha:1.0]
#define RGB_blue [UIColor colorWithRed:20/255.0 green:149/255.0 blue:206/255.0 alpha:1.0]


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIImageView *catImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *tiaotiaoImageView;
@property (nonatomic,strong)UIImageView *kouHaoImageView;
@property (nonatomic,strong)UIView *selectTitleView;
@property (nonatomic,strong)UIView *selectView;


@end

@implementation ViewController

- (UIImageView *)catImageView
{
    if (!_catImageView) {
        _catImageView = [[UIImageView alloc]init];
        NSMutableArray *catArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 61; i ++) {
            NSString *catPicString = [NSString stringWithFormat:@"smoke%d",i+1];
            UIImage *catPic = [UIImage imageNamed:catPicString];
            [catArray addObject:catPic];
        }
        [_catImageView setAnimationImages:catArray];
        [_catImageView setAnimationDuration:6];
        
    }
    return _catImageView;
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


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"欢迎光临蜜蜂拼图";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = 0;
    }
    return _titleLabel;
}

- (UIImageView *)kouHaoImageView
{
    if (!_kouHaoImageView) {
        _kouHaoImageView = [[UIImageView alloc]init];
        [_kouHaoImageView setImage:[UIImage imageNamed:@"kouhao"]];
    }
    return _kouHaoImageView;
}

- (UIView *)selectTitleView
{
    if (!_selectTitleView) {
        _selectTitleView = [[UIView alloc]init];
        NSArray *selectTitleArray = @[@"简单",@"困难",@"噩梦"];
        NSArray *colorArray = @[RGB_yellow,RGB_red,RGB_blue];
        
        for (int i = 0; i < 3; i ++) {
            UILabel *selectLabel = [[UILabel alloc]init];
            selectLabel.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 20);
            selectLabel.font = [UIFont systemFontOfSize:18];
            selectLabel.textAlignment = 1;
            selectLabel.textColor = colorArray[i];
            selectLabel.text = selectTitleArray[i];
            [_selectTitleView addSubview:selectLabel];
        }
 
    }
    return _selectTitleView;
}

- (UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        
        for (int i = 0; i < 3; i ++) {
            UIButton *theImageButton = [[UIButton alloc]init];
            theImageButton.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, ScreenWidth/3);
            [theImageButton setImage:[UIImage imageNamed:@"select"] forState:0];
            [_selectView addSubview:theImageButton];
            theImageButton.tag = 101+i;
            [theImageButton addTarget:self action:@selector(BeeImageAction:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return _selectView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addSubView];
    [self SubViewLayout];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)creatUI
{

    UIButton *selectbutton = [[UIButton alloc]init];
    [selectbutton setImage:[UIImage imageNamed:@"select"] forState:0];
    [self.view addSubview:selectbutton];
    [selectbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kouHaoImageView.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)addSubView
{
    [self.view addSubview:self.catImageView];
    [self.catImageView startAnimating];
    [self.view addSubview:self.tiaotiaoImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.kouHaoImageView];
    [self.view addSubview:self.selectTitleView];
    [self.view addSubview:self.selectView];
}

- (void)SubViewLayout
{
    [self.catImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(24);
        make.width.height.equalTo(@120);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(44);
    }];
    

    [self.kouHaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(80);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth-100);
        make.height.mas_equalTo((ScreenWidth-100)/1.5);
    }];
    
    [self.tiaotiaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.kouHaoImageView.mas_top).offset(0);
        make.width.height.equalTo(@80);
        make.right.mas_equalTo(25);
    }];
    
    [self.selectTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kouHaoImageView.mas_bottom).offset(20);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(20);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kouHaoImageView.mas_bottom).offset(50);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(100);
    }];
    
    
}



- (void)nextAction
{
    BeeSlicingViewController *beeVC = [[BeeSlicingViewController alloc]init];
    beeVC.name = @"candy";
    beeVC.colums = beeVC.rows = 3;
    [self.navigationController pushViewController:beeVC animated:YES];
}

- (void)BeeImageAction:(UIButton *)sender{
    switch (sender.tag) {
        case 101:
        {
            BeeSlicingViewController *beeVC = [[BeeSlicingViewController alloc]init];
            beeVC.name = @"candy";
            beeVC.colums = beeVC.rows = 3;
            beeVC.title = @"简单";
            [self.navigationController pushViewController:beeVC animated:YES];
        }
            break;
        case 102:
        {
            BeeSlicingViewController *beeVC = [[BeeSlicingViewController alloc]init];
            beeVC.name = @"xiuxiu";
            beeVC.colums = beeVC.rows = 4;
            beeVC.title = @"困难";
            [self.navigationController pushViewController:beeVC animated:YES];
        }
            break;
        case 103:
        {
            BeeSlicingViewController *beeVC = [[BeeSlicingViewController alloc]init];
            beeVC.name = @"Bee";
            beeVC.colums = beeVC.rows = 5;
            beeVC.title = @"噩梦";
            [self.navigationController pushViewController:beeVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
