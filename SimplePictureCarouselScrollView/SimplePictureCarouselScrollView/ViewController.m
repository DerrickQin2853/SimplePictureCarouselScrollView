//
//  ViewController.m
//  SimplePictureCarouselScrollView
//
//  Created by admin on 16/8/26.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

#import "CycleView.h"
#import "ViewController.h"

@interface ViewController () <CycleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CycleView *myView = [[CycleView alloc]
      initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width,
                               230)];

  NSArray *picDataArray = @[ @"1", @"2", @"3", @"4", @"5" ];

  NSArray *titleDataArray = @[ @"1", @"2", @"3", @"4", @"5" ];

  myView.picDataArray = [picDataArray copy];

  myView.titleDataArray = [titleDataArray copy];

  myView.titleLabelTextColor =
      [UIColor colorWithRed:0.2739 green:0.3203 blue:0.5724 alpha:1.0];

  myView.isAutomaticScroll = YES;

  myView.automaticScrollDelay = 2;

  myView.cycleViewStyle = CycleViewStyleBoth;

  myView.pageControlTintColor = [UIColor blackColor];

  myView.pageControlCurrentColor =
      [UIColor colorWithRed:0.8085 green:0.6715 blue:0.168 alpha:1.0];

  myView.delegate = self;

  [self.view addSubview:myView];
}

- (void)whenCycleClick:(NSInteger)index {

  NSLog(@"%zd", index);
}

@end
