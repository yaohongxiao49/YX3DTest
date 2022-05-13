//
//  YX3DBallCollectionViewLayout.m
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#import "YX3DBallCollectionViewLayout.h"

@implementation YX3DBallCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
}

#pragma mark - 返回的滚动范围增加对x轴的兼容
- (CGSize)collectionViewContentSize {
    
    CGFloat width = self.collectionView.frame.size.width * ([self.collectionView numberOfItemsInSection:0] + 2);
    CGFloat height = self.collectionView.frame.size.height * ([self.collectionView numberOfItemsInSection:0] + 2);
    
    return CGSizeMake(width, height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger itemCounts = [self.collectionView numberOfItemsInSection:0];
    attributes.center = CGPointMake(self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x, self.collectionView.frame.size.height / 2 + self.collectionView.contentOffset.y);
    attributes.size = CGSizeMake(30, 30);
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1 / 900.0;

    CGFloat radius = 15 / tanf(M_PI * 2 / itemCounts / 2);
    //根据偏移量 改变角度
    //添加了一个x的偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat offsetY = self.collectionView.contentOffset.y;
    //分别计算偏移的角度
    CGFloat angleOffsetX = offsetX / self.collectionView.frame.size.width;
    CGFloat angleOffsetY = offsetY / self.collectionView.frame.size.height;
    
    CGFloat angleFirst = (indexPath.row + angleOffsetY - 1) / itemCounts * M_PI * 2;
    //x,y的默认方向相反
    CGFloat angleSecond = (indexPath.row - angleOffsetX - 1) / itemCounts * M_PI * 2;
    
    //进行四个方向排列
//    if (indexPath.row % 4 == 1) {
//        transform3D = CATransform3DRotate(transform3D, angleFirst, 1.0, 0, 0);
//    }
//    else if (indexPath.row % 4 == 2) {
//        transform3D = CATransform3DRotate(transform3D, angleSecond, 0, 1, 0);
    transform3D = CATransform3DRotate(transform3D, angleSecond, 0, 1, 0.1);
//    }
//    else if (indexPath.row % 4 == 3) {
//        transform3D = CATransform3DRotate(transform3D, angleFirst, 0.5, 0.5, 0);
//    }
//    else {
//        transform3D = CATransform3DRotate(transform3D, angleFirst, 0.5, -0.5, 0);
//    }

    transform3D = CATransform3DTranslate(transform3D, 0, 0, radius);
    attributes.transform3D = transform3D;
    return attributes;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}

@end
