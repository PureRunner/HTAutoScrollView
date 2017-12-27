//
//  AutoScrollCell.m
//  RuntimeTest
//
//  Created by shuai pan on 2017/12/26.
//  Copyright © 2017年 foreveross. All rights reserved.
//

#import "AutoScrollCell.h"

typedef void(^DidClicked)(NSInteger);
@interface AutoScrollCell()

@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UILabel *descLable;

@property (nonatomic ,copy)DidClicked didClickBlock;

@end
@implementation AutoScrollCell

- (id)initWithFrame:(CGRect)frame didClicked:(void(^)(NSInteger index))didClickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _didClickBlock = didClickBlock;
        [self ht_initializeControls];
    }
    return self;
}
#pragma mark Private Method
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:_imageName];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    self.imageView.image = [UIImage imageWithData:data];
}
- (void)ht_initializeControls {
    self.backgroundColor = [UIColor colorWithRed:(arc4random()%222)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    [self addSubview:self.descTitle];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPictureUrlLink:)];
    [self addGestureRecognizer:tap];
    
}
- (void)jumpToPictureUrlLink:(UITapGestureRecognizer*)tap {
    if (self.didClickBlock) {
        self.didClickBlock(self.index);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.descTitle.frame = CGRectMake(0.f, CGRectGetHeight(self.frame)/8, CGRectGetWidth(self.frame), 30.f);
    self.imageView.frame = self.bounds;

}
#pragma mark Private Method - UI
- (UILabel *)descTitle {
    if (!_descLable) {
        _descLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _descLable.textAlignment = NSTextAlignmentCenter;
    }
    return _descLable;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}



//- (NSString *)description {
//
//    NSDictionary *cell = @{@"index":[NSNumber numberWithInteger:self.index],
//                           @"imageName":self.imageName,
//                           @"identifier":[NSNumber numberWithInteger:self.identifier]};
//    return [NSString stringWithFormat:@"cell: %@",cell];
//}

@end
