//
//  BeeSlicingViewController.m
//  BeePuzzle
//
//  Created by Ji_YuFeng on 16/12/29.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "BeeSlicingViewController.h"
#import "BeePuzzleCollectionViewCell.h"
#import <Masonry.h>
#import "BeeShowPicViewController.h"
#import "BeeTiShiViewController.h"

@interface BeeSlicingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>


//定义切割的行列数
#define kColumns self.colums
#define kRows self.rows
//切割后总的碎片数
#define kNumbers (kColumns*kRows)
//间距
#define kMargin 2
//碎片的长宽尺寸
#define kWidth ((self.view.frame.size.width-2*kStartX-(kColumns-1)*kMargin)/kColumns)
#define kHeight ((self.view.frame.size.height-kStartY-bigHeight-(kRows+2)*kMargin)/kRows)

#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width


@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *cutImageArray;
@property (nonatomic,strong)NSMutableArray *sxArray;
@property (nonatomic,strong)NSMutableArray *TheNumArray;

@end

@implementation BeeSlicingViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.collectionViewLayout = _layout;
        
        // 1.设置列间距
        _layout.minimumInteritemSpacing = 1;
        // 2.设置行间距
        _layout.minimumLineSpacing = 1;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        [_collectionView registerClass:[BeePuzzleCollectionViewCell class] forCellWithReuseIdentifier:@"BeePuzzleCollectionViewCell"];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.sxArray = [NSMutableArray new];
    self.TheNumArray = [NSMutableArray new];
    for (int i = 0; i < kNumbers; i++) {
        [self.TheNumArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.cutImageArray = [self cutImage:self.name];
    self.dataArray = [self randomArray];
    self.navigationController.title = self.title;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.equalTo(@50);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocation:)];
    [self.collectionView addGestureRecognizer:pan];
 
    [self.rightbtn setTitle:@"原图" forState:0];
    
    
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kNumbers;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BeePuzzleCollectionViewCell *beeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BeePuzzleCollectionViewCell" forIndexPath:indexPath];
    [beeCell.candyImage setImage:self.dataArray[indexPath.row]];
    return beeCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-19-kColumns)/kColumns, (ScreenWidth-19-kColumns)/kColumns);
}

#pragma mark - 手势动画

- (void)changeLocation:(id)sender
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    UIGestureRecognizerState state = pan.state;
    
    CGPoint point = [pan locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    static UIView *snapshot = nil;             //创建cell的一个快照
    static NSIndexPath *sourceIndexPath = nil; //手势开始的cell的indexPath
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath)
            {
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                //获取当前cell的快照 即手势起始拖动的那个cell
                //                snapshot = [self customSnapshoFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                //向collectionView上添加快照视图
                [self.collectionView addSubview:snapshot];
                //添加一个动画效果
                [UIView animateWithDuration:0.25 animations:^{
                    
                    snapshot.center = point;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            snapshot.center = point;
            
            //如果改变位置的cell存在 且与源cell位置不同 且2个cell处于同一个分区
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.section == sourceIndexPath.section)
            {
                
                //                if (sourceIndexPath.section == 0)
                //                {
                //                    [arr1 exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //                }
                //                else
                //                {
                //                    [arr2 exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //                }
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                NSInteger a = [self.sxArray[sourceIndexPath.row]intValue];
                
                [self.sxArray removeObjectAtIndex:sourceIndexPath.row];
                [self.sxArray insertObject:[NSNumber numberWithInt:a] atIndex:indexPath.row];
                
                sourceIndexPath = indexPath;
                
                
            }
            break;
        }
            
        default:
        {
            //从视图上移除快照
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.backgroundColor = [UIColor redColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            
            if ([self.sxArray isEqualToArray: self.TheNumArray]) {
                NSLog(@"成功");
                
                [self doTheSuccess];
                
            }
            
            
            
            
            break;
        }
    }
    
    
    
}

-(NSArray *)randomArray
{
    NSMutableArray *startArray=[[NSMutableArray alloc]initWithArray:self.cutImageArray];
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    NSInteger m=kNumbers;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        [startArray removeObjectAtIndex:t];
        NSInteger theIndex = [self.cutImageArray indexOfObject:resultArray[i]];
        [self.sxArray addObject:[NSNumber numberWithInt:theIndex]];
        
    }
        
    return resultArray;
}

#pragma mark - 切图函数
-(NSArray *)cutImage:(NSString *)imageName
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    UIImage *image = self.image;
    for(int i=0;i<kNumbers;i++)
    {
        int row=i/kColumns;
        int column=i%kColumns;
        
        CGImageRef imageRef=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(column*image.size.width*2/kColumns, row*image.size.height*2/kRows, image.size.width*2/kColumns, image.size.height*2/kRows));
        UIImage *cutImage=[UIImage imageWithCGImage:imageRef];
        [array addObject:cutImage];
        
    }
    return array;
}

#pragma mark - 拼图成功
- (void)doTheSuccess
{

    BeeShowPicViewController *vc = [BeeShowPicViewController new];
    CATransition *animation = [CATransition animation];
    animation.duration = 2.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    vc.theImage = self.image;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self presentViewController:vc animated:NO completion:nil];
    
}

#pragma mark - 原图
- (void)rightButtonAction:(UIButton *)sender
{
    BeeTiShiViewController *vc = [BeeTiShiViewController new];
    vc.theImage = self.image;
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.subtype = kCATransitionMoveIn;

    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:vc animated:NO completion:nil];
}





@end
