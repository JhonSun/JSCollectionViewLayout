//
//  CWPictureWallCollectionViewLayout.m
//  TheCloudWisdom
//
//  Created by drision on 2017/2/15.
//  Copyright © 2017年 drision. All rights reserved.
//

#import "CWPictureWallCollectionViewLayout.h"

#define NewDefaultCollectionViewWidth  self.collectionView.frame.size.width

//static 只在当前作用域使用 const 不可修改的
static const UIEdgeInsets NewDefaultInsets={5,5,5,5};

//定义行列之间的间距
static const CGFloat NewDefaultColumn = 10;

//定义默认的列数
static int NewDeraultNumber = 2;

//额外的高度
static CGFloat const extraHeight = 15 + 5 + 20 + 5;

@interface CWPictureWallCollectionViewLayout ()

//创建数组存放 Y值最大值 存放cell的布局属性
@property(nonatomic,strong) NSMutableArray *columnArr;
@property(nonatomic,strong) NSMutableArray *cellArr;

@end

@implementation CWPictureWallCollectionViewLayout

- (NSMutableArray *)columnArr{
    if (!_columnArr) {
        _columnArr=[NSMutableArray array];
    }
    return _columnArr;
}

- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr =[NSMutableArray array];
    }
    
    return _cellArr;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //布局属性刷新更改
    
    //获取总的横向间距
    
    CGFloat xMARGIN=NewDefaultInsets.left+NewDefaultInsets.right+(NewDeraultNumber-1)*NewDefaultColumn;
    
    CGFloat width=(NewDefaultCollectionViewWidth-xMARGIN)/NewDeraultNumber;
    
#pragma mark -- 这里返回图片的高度
    
    UIImage *image = self.imageList[indexPath.item];
    
    CGFloat height=image.size.height *(width/image.size.width) + extraHeight;
    
#pragma mark -- 这里我们需要获取x坐标的值 如何获取 因为我们要做的是将需要展示的数组按顺序向下排列 而顺序就将后进来的插入到 最短的那一列 所以要获取这个x坐标我们就需要找出这个最小的y坐标才能确定
    NSInteger sum=0;
    
#pragma mark -- 下面这个遍历为什么要使用也是上面的原因 取出最大的y值 并获取对应的列数 其实columnArr只有三个元素
    CGFloat sumMaxY=[self.columnArr[0] doubleValue];
    
    for (int i=0; i<self.columnArr.count; i++) {
        
        CGFloat anyMaxY=[self.columnArr[i]doubleValue];
        
        if (sumMaxY>anyMaxY) {
            
            sumMaxY=anyMaxY;
            
            sum=i;
        }
    }
    
    CGFloat x=NewDefaultInsets.left +sum*(width+NewDefaultColumn);
    
    CGFloat y=NewDefaultInsets.top+sumMaxY;
    
    attr.frame=CGRectMake(x, y, width, height);
    
    //更新数组，获取最大的Y 下一次比较时用到  记住每一次都会走下面这个方法  而这个方法 第一次的时候都是0 第二次的时候两个0 第三次的时候就不一样了
    self.columnArr[sum]=@(CGRectGetMaxY(attr.frame));
    
    return attr;
}

#pragma mark -- 这里下面的方法 是当我们向上或向下滑动item的时候 我们需要将我们的最大Y坐标重置 为什么呢 因为如果你继续使用最大Y坐标 它还是向下排列
- (void)prepareLayout{
    [super prepareLayout];
    
    //设置cell的最大Y值
    [self.columnArr removeAllObjects];
    
    for (int i=0; i<NewDeraultNumber; i++) {
        
        //这里使用下面的方法是给最大值一个初始值
        [self.columnArr addObject:@(NewDefaultInsets.top)];
        
    }
    
    //设置cell的布局属性  这里的self.layoutAttributesForItemAtIndexPath 是本类的一个属性 通过对应的indexPath我们可以拿到对应的item的布局属性 然后存储起来
    [self.cellArr removeAllObjects];
    
    NSInteger count=[self.collectionView numberOfItemsInSection:0];
    
    for (int i=0; i<count; i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.cellArr addObject:attrs];
    }
    
    
}

#pragma mark -- 设置collectionView的范围 contentSize
- (CGSize)collectionViewContentSize{
    
    CGFloat sumMaxY=[self.columnArr[0] doubleValue];
    
    for (int i=0; i<self.columnArr.count; i++) {
        
        CGFloat anyMaxY=[self.columnArr[i]doubleValue];
        
        if (sumMaxY<anyMaxY) {
            
            sumMaxY=anyMaxY;
        }
    }
    
    //这里返回的横坐标是什么都可以
    return CGSizeMake(0, sumMaxY);
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    //在里我们将我们存储起来的item布局属性交付给cell
    return self.cellArr;
}

@end
