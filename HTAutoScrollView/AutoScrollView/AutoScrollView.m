//
//  AutomaticPlay.m
//  BSLFMDB
//
//  Created by Foreveross BSL on 16/8/25.
//  Copyright © 2016年 Foreveross BSL. All rights reserved.
//

#define VIEW_W(view) CGRectGetWidth(((UIView*)view).frame)

#import "AutoScrollView.h"
#import "AutoScrollCell.h"
#import <objc/runtime.h>
@interface AutoScrollView ()<UIScrollViewDelegate > {
}
@property (nonatomic, strong)UIScrollView   *scroll;
@property (nonatomic, strong)UIPageControl  *pageControl;

@property (nonatomic, strong)NSMutableArray *fillCells;

@property (nonatomic, strong)NSTimer *timer;

@end
@implementation AutoScrollView

-(id)initWithFrame:(CGRect)frame delegate:(id <AutoScrollViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        [self ht_initializeControlsWithDelegate:delegate];
    }
    return self;
}
- (void)ht_initializeControlsWithDelegate:(id <AutoScrollViewDelegate>)delegate {
    self.automaticPlay = NO;
    self.showPageControl = NO;
    [self addSubview:self.scroll];
    self.delegate = delegate;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat scroll_w = VIEW_W(scrollView);
    int multiple = (int)(x/scroll_w);
//    NSLog(@"%d",multiple);
    [self scrollMultiple:multiple];
}

#pragma mark Private Method
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self fillCellsWithDataSource:_dataSource];
}

- (void)setAutomaticPlay:(BOOL)automaticPlay{
    _automaticPlay = automaticPlay;
    if (_automaticPlay) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
    else {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)startAutomaticPlay:(NSTimer *)timer {
    CGFloat x = self.scroll.contentOffset.x;
    int multiple = (int)(x/VIEW_W(self.scroll))+1;
    [self scrollMultiple:multiple];
}
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (_showPageControl){
        [self addSubview:self.pageControl];
    }
}

//添加scroll cells
- (void)fillCellsWithDataSource:(NSArray *)dataSource {
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < dataSource.count + 2; i ++) {
        AutoScrollCell *cell = [[AutoScrollCell alloc] initWithFrame:CGRectZero didClicked:^(NSInteger index) {
            if( [weakSelf.delegate respondsToSelector:
                 @selector(autoScrollView:didClickedCell:)]){
                [weakSelf.delegate autoScrollView:weakSelf didClickedCell:index];
            }
        }];
        if (i == dataSource.count + 1) {
            cell.index = 0;
        }
        else if(i == 0){
            cell.index = dataSource.count - 1;
        }
        else{
            cell.index = i-1;
        }
        cell.identifier = i;
        NSString *imageSource = dataSource[cell.index];
        if ([imageSource validUrlString]) {
            cell.imageUrl = dataSource[cell.index];

        }else {
            cell.imageName = dataSource[cell.index];
        }
        [self.fillCells addObject:cell];
        [self.scroll addSubview:cell];
    }
    if (self.showPageControl) {
        self.pageControl.numberOfPages = self.fillCells.count-2;
    }
}

//滑动偏移
- (void)scrollMultiple:(int)multiple {
     [self.scroll setContentOffset:(CGPointMake(VIEW_W(self.scroll)*multiple, 0)) animated:YES];
    float timeInterval = self.automaticPlay? 0.5f:0.0f;
    if (multiple == self.fillCells.count-1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scroll setContentOffset:(CGPointMake(VIEW_W(self.scroll), 0)) animated:NO];
        });
    }
    if (multiple == 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scroll setContentOffset:(CGPointMake((self.fillCells.count-2) *VIEW_W(self.scroll), 0)) animated:NO];
        });
    }
    //pageControl 设置
    for (id view in self.scroll.subviews) {
        if ([view isKindOfClass:[AutoScrollCell class]]) {
            AutoScrollCell *cell = (AutoScrollCell *)view;
            if (cell.identifier == multiple ) {
                self.pageControl.currentPage = cell.index;
            }
        }
    }
}


#pragma mark - UI
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat self_w = CGRectGetWidth(self.frame);
    CGFloat self_h = CGRectGetHeight(self.frame);
    self.scroll.frame = CGRectMake(0, 0, self_w , self_h);
    
    for (int i = 0; i < self.fillCells.count; i ++ ) {
        AutoScrollCell *cell = (AutoScrollCell *)self.fillCells[i];
        cell.frame = CGRectMake(self_w * i, 0, self_w, self_h);
    }
    if (self.showPageControl) {
        self.pageControl.frame = CGRectMake(self_w - 110.f, (self_h*9)/10, 100.f, 25.f);
    }
    self.scroll.contentSize = CGSizeMake(self_w*self.fillCells.count , self_h);
    self.scroll.contentOffset = CGPointMake(self_w, 0);
    
}

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scroll.backgroundColor = [UIColor cyanColor];
        _scroll.pagingEnabled = YES;
        _scroll.delegate = self;
    }
    return _scroll;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//        [_pageControl addTarget:self action:@selector(pageControllerValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _pageControl;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(startAutomaticPlay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
    return _timer;
}
- (NSMutableArray *)fillCells {
    if (!_fillCells) {
        _fillCells = [NSMutableArray arrayWithCapacity:2];
    }
    return _fillCells;
}

- (void)removeAutoScroll {
    [self removeFromSuperview];
    [_timer setFireDate:[NSDate distantFuture]];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc {
    NSLog(@"AutoScrollView dealloc");
    
}
@end


@implementation NSString (Url)

//有效的网址
- (BOOL)validUrlString{
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

@end
