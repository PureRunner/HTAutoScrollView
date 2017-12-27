//
//  AutomaticPlay.h
//  BSLFMDB
//
//  Created by Foreveross BSL on 16/8/25.
//  Copyright © 2016年 Foreveross BSL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AutoScrollView;
@protocol AutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(AutoScrollView*)autoScroll didClickedCell:(NSInteger)index;
@end


@interface AutoScrollView : UIView
@property (nonatomic ,assign)BOOL showPageControl;//自动播放
@property (nonatomic ,assign)BOOL automaticPlay;//自动播放
@property (nonatomic ,strong)NSArray *dataSource; 

@property (nonatomic ,assign)id <AutoScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id <AutoScrollViewDelegate>)delegate ;
- (void)removeAutoScroll;

@end


@interface NSString (Url)
//有效的网址
- (BOOL)validUrlString;
@end
