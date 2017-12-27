//
//  ViewController.m
//  HTAutoScrollView
//
//  Created by shuai pan on 2017/12/27.
//  Copyright © 2017年 foreveross. All rights reserved.
//

#import "ViewController.h"
#import "AutoScrollView.h"

@interface ViewController ()<AutoScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AutoScrollView *autoScroll = [[AutoScrollView alloc] initWithFrame:self.view.bounds delegate:self];
    [self.view addSubview:autoScroll];
    autoScroll.showPageControl = YES;
    autoScroll.dataSource = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514374532719&di=86ce33556d1b2411f63b0f72e66c4de4&imgtype=0&src=http%3A%2F%2Fs10.sinaimg.cn%2Fmw690%2F002Ss8Mkgy72zJlhskV69%26690",
                              @"bg_autoScroll.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514374630746&di=54afb36956efa895107cd08b80db4554&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F500fd9f9d72a60597fbf38cb2234349b023bbab0.jpg"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        autoScroll.automaticPlay = YES;
    });
}
- (void)autoScrollView:(AutoScrollView *)autoScroll didClickedCell:(NSInteger)index {
    NSLog(@"%@",[NSNumber numberWithInteger:index]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
