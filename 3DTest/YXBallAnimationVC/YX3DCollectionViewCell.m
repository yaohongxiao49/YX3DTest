//
//  YX3DCollectionViewCell.m
//  3DTest
//
//  Created by Augus on 2022/5/16.
//

#import "YX3DCollectionViewCell.h"

@interface YX3DCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation YX3DCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

- (void)reloadValueByArr:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath {
    
    self.titleLab.text = arr[indexPath.row];
}

- (void)initView {
    
    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

@end
