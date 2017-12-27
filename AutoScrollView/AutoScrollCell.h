//
//  AutoScrollCell.h
//  RuntimeTest
//
//  Created by shuai pan on 2017/12/26.
//  Copyright © 2017年 foreveross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoScrollCell : UIView

@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,assign)NSInteger identifier;

@property (nonatomic ,strong)NSString *imageName;
@property (nonatomic ,strong)NSString *imageUrl;

- (id)initWithFrame:(CGRect)frame didClicked:(void(^)(NSInteger index))didClickBlock;
@end
