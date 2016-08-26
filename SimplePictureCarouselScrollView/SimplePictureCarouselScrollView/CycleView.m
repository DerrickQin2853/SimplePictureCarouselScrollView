//
//  CycleView.m
//  SimplePictureCarouselScrollView
//
//  Created by admin on 16/8/26.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

#import "CycleView.h"

#define kImageCount _picDataArray.count
#define kTitleLabelW 200
#define KTitleLabelH 25
#define kMargin 20
#define kPageControlW 100
#define kPageControlH 25

@interface CycleView () <UIScrollViewDelegate>
@property(nonatomic, weak) UIScrollView *mainScrollView;
@property(nonatomic, weak) UIImageView *centerImageView;
@property(nonatomic, weak) UIImageView *leftImageView;
@property(nonatomic, weak) UIImageView *rightImageView;
@property(nonatomic, assign) NSInteger leftImageIndex;
@property(nonatomic, assign) NSInteger rightImageIndex;
@property(nonatomic, weak) UIPageControl *pageControl;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGRect TitleFrame;
@property(nonatomic, assign) CGRect PageControlFrame;

@end

@implementation CycleView

- (instancetype)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];

  if (self) {
    [self setupSubviews];
    [self setupTitleLabel];
    [self setupPageControl];
  }
  return self;
}

- (void)scrollViewClick:(UITapGestureRecognizer *)tap {

  if ([self.delegate respondsToSelector:@selector(whenCycleClick:)]) {

    [self.delegate whenCycleClick:self.currentImageIndex];
  }
}

- (void)setPicDataArray:(NSArray *)picDataArray {
  _picDataArray = picDataArray;

  _pageControl.numberOfPages = picDataArray.count;

  [self reloadImageViews];
}

- (void)setTitleDataArray:(NSArray *)titleDataArray {
  _titleDataArray = titleDataArray;

  _titleLabel.hidden = NO;

  [self reloadImageViews];
}

- (void)setupSubviews {

  UIScrollView *mainScrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                               self.bounds.size.height)];

  mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);

  mainScrollView.bounces = NO;

  mainScrollView.pagingEnabled = YES;

  mainScrollView.showsHorizontalScrollIndicator = NO;

  mainScrollView.showsVerticalScrollIndicator = NO;

  [mainScrollView setBackgroundColor:[UIColor clearColor]];

  _mainScrollView = mainScrollView;

  _mainScrollView.delegate = self;

  [self addSubview:mainScrollView];

  [_mainScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)
                           animated:NO];

  UIImageView *leftImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                               self.bounds.size.height)];
  _leftImageView = leftImageView;

  UIImageView *rightImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(2 * self.bounds.size.width,
                                                    0, self.bounds.size.width,
                                                    self.bounds.size.height)];
  _rightImageView = rightImageView;

  UIImageView *centerImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0,
                                                    self.bounds.size.width,
                                                    self.bounds.size.height)];

  centerImageView.userInteractionEnabled = YES;

  _centerImageView = centerImageView;

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(scrollViewClick:)];

  [centerImageView addGestureRecognizer:tap];

  [self.mainScrollView addSubview:leftImageView];
  [self.mainScrollView addSubview:rightImageView];
  [self.mainScrollView addSubview:centerImageView];

  [_mainScrollView
      setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
              animated:NO];
}

- (void)setupTitleLabel {

  UILabel *titleLabel = [[UILabel alloc] init];

  titleLabel.hidden = YES;

  _titleLabel = titleLabel;

  [self addSubview:titleLabel];
}

- (void)setupPageControl {

  UIPageControl *pageControl = [[UIPageControl alloc] init];

  pageControl.numberOfPages = _picDataArray.count;

  _pageControl = pageControl;

  pageControl.tintColor = _pageControlTintColor;

  pageControl.currentPageIndicatorTintColor = _pageControlCurrentColor;

  [self addSubview:pageControl];
}

- (void)automaticScroll {

  CGPoint currentPoint = _mainScrollView.contentOffset;

  currentPoint.x += _mainScrollView.bounds.size.width;

  [_mainScrollView setContentOffset:currentPoint animated:YES];
}

- (void)setIsAutomaticScroll:(BOOL)isAutomaticScroll {

  _isAutomaticScroll = isAutomaticScroll;

  [self endMyTimer];

  if (isAutomaticScroll) {
    [self startMyTimer];
  }
}

- (NSInteger)leftImageIndex {

  if (_currentImageIndex == 0) {

    _leftImageIndex = kImageCount - 1;

  } else {

    _leftImageIndex = _currentImageIndex - 1;
  }

  return _leftImageIndex;
}

- (NSInteger)rightImageIndex {

  if (_currentImageIndex == kImageCount - 1) {

    _rightImageIndex = 0;
  } else {

    _rightImageIndex = _currentImageIndex + 1;
  }

  return _rightImageIndex;
}

- (void)currentImageIndexAdd {

  if (self.currentImageIndex == kImageCount - 1) {

    self.currentImageIndex = 0;
  } else {
    self.currentImageIndex = self.currentImageIndex + 1;
  }
}

- (void)currentImageIndexMinus {

  if (self.currentImageIndex == 0) {

    self.currentImageIndex = kImageCount - 1;

  } else {

    self.currentImageIndex = self.currentImageIndex - 1;
  }
}

- (void)reloadImageViews {

  CGPoint scrollViewOffset = [_mainScrollView contentOffset];

  if (scrollViewOffset.x == 2 * _mainScrollView.bounds.size.width) {

    [self currentImageIndexAdd];

  } else if (scrollViewOffset.x == 0) {

    [self currentImageIndexMinus];
  }

  _centerImageView.image =
      [UIImage imageNamed:_picDataArray[self.currentImageIndex]];

  _currentImageName = _picDataArray[self.currentImageIndex];
  _leftImageView.image =
      [UIImage imageNamed:_picDataArray[self.leftImageIndex]];
  _rightImageView.image =
      [UIImage imageNamed:_picDataArray[self.rightImageIndex]];

  _titleLabel.text = _titleDataArray[self.currentImageIndex];
  _pageControl.currentPage = self.currentImageIndex;
}

- (void)startMyTimer {

  if (self.isAutomaticScroll) {
    NSTimer *newTimer =
        [NSTimer scheduledTimerWithTimeInterval:self.automaticScrollDelay
                                         target:self
                                       selector:@selector(automaticScroll)
                                       userInfo:nil
                                        repeats:YES];

    _timer = newTimer;

    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
  }
}

- (void)endMyTimer {

  if (self.isAutomaticScroll) {
    [_timer invalidate];

    _timer = nil;
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {

  [self startMyTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

  [self endMyTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGPoint scrollViewOffset = scrollView.contentOffset;

  if (scrollViewOffset.x > 1.5 * _mainScrollView.bounds.size.width) {

    _pageControl.currentPage = self.rightImageIndex;

    _titleLabel.text = _titleDataArray[self.rightImageIndex];

  } else if (scrollViewOffset.x < 0.5 * _mainScrollView.bounds.size.width) {

    _pageControl.currentPage = self.leftImageIndex;

    _titleLabel.text = _titleDataArray[self.leftImageIndex];
  }

  else {
    _pageControl.currentPage = self.currentImageIndex;

    _titleLabel.text = _titleDataArray[self.currentImageIndex];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

  [self reloadImageViews];

  [_mainScrollView
      setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
              animated:NO];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

  [self reloadImageViews];

  [_mainScrollView
      setContentOffset:CGPointMake(_mainScrollView.bounds.size.width, 0)
              animated:NO];
}

- (NSUInteger)currentImageIndex {

  if (!_currentImageIndex) {

    _currentImageIndex = 0;
  }

  return _currentImageIndex;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont {

  _titleLabelTextFont = titleLabelTextFont;
  _titleLabel.font = titleLabelTextFont;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor {
  _titleLabelTextColor = titleLabelTextColor;
  _titleLabel.textColor = titleLabelTextColor;
}

- (void)setPageControlTintColor:(UIColor *)pageControlTintColor {
  _pageControlTintColor = pageControlTintColor;

  _pageControl.tintColor = pageControlTintColor;
}

- (void)setPageControlCurrentColor:(UIColor *)pageControlCurrentColor {
  _pageControlCurrentColor = pageControlCurrentColor;

  _pageControl.currentPageIndicatorTintColor = pageControlCurrentColor;
}

- (float)automaticScrollDelay {

  if (!_automaticScrollDelay) {
    _automaticScrollDelay = 2.0;
  }

  return _automaticScrollDelay;
}

- (void)setAutomaticScrollDelay:(float)automaticScrollDelay {

  _automaticScrollDelay = automaticScrollDelay;

  [self setIsAutomaticScroll:self.isAutomaticScroll];
}

- (CycleViewStyle)cycleViewStyle {

  if (!_cycleViewStyle) {

    _cycleViewStyle = CycleViewStylePageControl;
  }

  return _cycleViewStyle;
}

- (void)setCycleViewStyle:(CycleViewStyle)cycleViewStyle {

  _cycleViewStyle = cycleViewStyle;

  if (cycleViewStyle == CycleViewStyleNone) {
    _TitleFrame = CGRectZero;
    _PageControlFrame = CGRectZero;
  } else if (cycleViewStyle == CycleViewStyleTitle) {
    _TitleFrame = CGRectMake((self.bounds.size.width - kTitleLabelW) / 2,
                             self.bounds.size.height - KTitleLabelH,
                             kTitleLabelW, KTitleLabelH);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _PageControlFrame = CGRectZero;
  } else if (cycleViewStyle == CycleViewStylePageControl) {
    _TitleFrame = CGRectZero;
    _PageControlFrame = CGRectMake((self.bounds.size.width - kPageControlW) / 2,
                                   self.bounds.size.height - kPageControlH,
                                   kPageControlW, kPageControlH);
  } else if (cycleViewStyle == CycleViewStyleBoth) {
    _TitleFrame = CGRectMake(kMargin, self.bounds.size.height - KTitleLabelH,
                             kTitleLabelW, KTitleLabelH);
    _PageControlFrame = CGRectMake(
        self.bounds.size.width - kPageControlW - kMargin,
        self.bounds.size.height - kPageControlH, kPageControlW, kPageControlH);
  }

  _pageControl.frame = _PageControlFrame;

  _titleLabel.frame = _TitleFrame;
}

@end
