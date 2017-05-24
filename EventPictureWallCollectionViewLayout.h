//
//  CWPictureWallCollectionViewLayout.h
//  TheCloudWisdom
//
//  Created by drision on 2017/2/15.
//  Copyright © 2017年 drision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPictureWallCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, copy) NSArray *imageHeightArray;//图片动态高度
@property (nonatomic, copy) NSArray *otherHeightArray;//其他空间的动态高度

@end
