#BeePuzzle<br>
蜜蜂拼图
====

项目使用了cocospod，又设置了忽略文件，所以下载的时候请自行 pod install 一下 <br>
而且采用了之前蜜蜂的图片封装，详见 [beeCustomPhoto](https://github.com/iOSJYF/beeCustomPhoto)   <br>
首先来一波效果图: <br>
![gif](https://github.com/iOSJYF/BeePuzzle/raw/master/xiaoguo.gif)   <br>    
![gif](https://github.com/iOSJYF/BeePuzzle/raw/master/xiaoguo2.gif)  <br>
<br>
拼图默认是正方形的裁剪，所以一开始进去截图比例是1：1，默认横竖切割数一样，难度对应切割分别为3、4、5。<br>




首页
------

* 对应控制器：ViewController <br>
首先进行图片的选择之后，在代理方法里我对图片进行了压缩（如果不进行压缩，图片太大会导致显示卡顿，因为拼图界面是对图片进行切割，图片太大可能导致CPU负载过多而崩溃）<br>
压缩方法如下:<br>
```object-c
#pragma mark - 压缩图片至指定大小
- (NSData *)beeCustomPic:(UIImage *)image ToCustomSize:(CGSize)size
{

   CGSize mysize = size;
   CGSize resize = image.size;
   if(resize.width > mysize.width){
        resize = CGSizeMake(mysize.width, mysize.width/resize.width * resize.height);
   }
   if(resize.height > mysize.height){
       resize = CGSizeMake(mysize.height/resize.height * resize.width, mysize.height);
    }
   if (resize.width <= 0 || resize.height <= 0) return nil;
   UIGraphicsBeginImageContextWithOptions(resize, NO, image.scale);
   [image drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
   UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   NSData *data = UIImageJPEGRepresentation(newimage, 1);
   return data;
}
```
拼图页面
------
* 对应控制器：BeeSlicingViewController <br>
这里我用了collectionView 作为拼图的基础控件，在cololectionView上加手势来进行判断 <br>
首先对传过来的image进行相对应的切割 <br>
行数: kColumns <br>
列数: kRows <br>
总共 kNumbers 块拼图  kNumbers = kColumns * kRows <br>
```object-c
-(NSArray *)cutImage:(NSString *)imageName
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    UIImage *image = self.image;
    for(int i=0;i<kNumbers;i++)
    {
        int row=i/kColumns;
        int column=i%kColumns;
        
        CGImageRef imageRef=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(column*image.size.width/kColumns, row*image.size.height/kRows, image.size.width/kColumns, image.size.height/kRows));
        UIImage *cutImage=[UIImage imageWithCGImage:imageRef];
        [array addObject:cutImage];
        
    }
    return array;
}
```
此时通过调用此方法可以得到 kNumbers 个图片，collectionView 相对应的设置 kNumbers 个cell，然后对此数组进行打乱，赋值于cell <br>
```object-c
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
        [self.sxArray addObject:[NSNumber numberWithInteger:theIndex]];
        
    }
        
    return resultArray;
}
```
在此方法中，我记录当前for循环随机出来的元素属于第几个，然后放到sxArray中，这样可以得到随机数组的一个排序，用以判断顺序，如果最后该数组的排序跟以顺序排列的数组 TheNumArray 一样，则可以判断完成拼图 <br>
之后就是手势的操作了，先在collectionView上添加手势 <br>
```object-c
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeLocation:)];
  [self.collectionView addGestureRecognizer:pan];
```
手势对应操作 <br>
这里手势方法在你拖拉的时候会触发三次，分别为：
* UIGestureRecognizerStateBegan     点击
* UIGestureRecognizerStateChanged   拖拽
* UIGestureRecognizerStateEnded     放开
<br>
<br>
* 在 UIGestureRecognizerStateBegan 中，通过 point 拿到对应的 indexPath,定义开始的 indexPath 为 sourceIndexPath <br>
* 在 UIGestureRecognizerStateChanged 中用拖拽后停下来的 indexPath 与 sourceIndexPath 做比较进行计算，直接调用 collectView 的方法 <br>
<br>

```object-c
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
```

<br>
用此方法进行cell的替换操作，本来蜜蜂认为这样就简单完事了，后来发现这样只能实现相邻row的一个替换，如果cell上下移动，实际上是相隔了好几个row，从而会导致顺序有点错乱，仔细研究了一下，发现这个方法其实是把前面的indexPath给remove然后在后面加上，而不是我们想要的A替换为B，B替换为A的操作，所以我在后面加了两个for循环处理，如果 sourceIndexPath 小于 indexPath，证明是向下滑动，会走进第一个for循环，我就反过来把indexPath一个个moveItem到sourceIndexPath的位置。同理可处理 sourceIndexPath 大于 indexPath 的情况，然后对sxArray进行一个排序更换，从而得到你排列的顺序 <br>
* 在 UIGestureRecognizerStateEnded 中将 sourceIndexPath 设为nil，并且对sxArray进行判断，如果排序跟 TheNumArray 一样，则拼图的顺序已经正确，
进行拼图成功操作


```object-c
- (void)changeLocation:(id)sender
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    UIGestureRecognizerState state = pan.state;
    
    CGPoint point = [pan locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    static NSIndexPath *sourceIndexPath = nil; //手势开始的cell的indexPath
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath)
            {
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            //如果改变位置的cell存在 且与源cell位置不同 且2个cell处于同一个分区
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.section == sourceIndexPath.section)
            {
                
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // 处理向下拖拽顺序错乱
                for (int i = (int)indexPath.row-1; i > (int)sourceIndexPath.row; i --) {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    NSIndexPath *index2 = [NSIndexPath indexPathForRow:i-1 inSection:0];
                    [self.collectionView moveItemAtIndexPath:index toIndexPath:index2];
                }
                // 处理向上拖拽顺序错乱
                for (int i = (int)indexPath.row+1; i < (int)sourceIndexPath.row; i ++) {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                    NSIndexPath *index2 = [NSIndexPath indexPathForRow:i+1 inSection:0];
                    [self.collectionView moveItemAtIndexPath:index toIndexPath:index2];
                }

                int a = [self.sxArray[sourceIndexPath.row]intValue];
                
                [self.sxArray removeObjectAtIndex:sourceIndexPath.row];
                [self.sxArray insertObject:[NSNumber numberWithInt:a] atIndex:indexPath.row];
                sourceIndexPath = indexPath;

            }
            break;
        }
            
        default:
        {
            sourceIndexPath = nil;
            if ([self.sxArray isEqualToArray: self.TheNumArray]) {
                [self doTheSuccess];
            }
            break;
        }
    }
}

```

新手开车，大神们多多指教~！




