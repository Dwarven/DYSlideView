//
//  DYSlideView.m
//  DYSlideView
//
//  Created by Dwarven on 16/4/18.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "DYSlideView.h"

@interface DYSlideView () <UIScrollViewDelegate> {
    NSInteger _numberOfViewControllers;
    UIView * _slideBar;
    UIView * _slider;
    NSMutableArray *_slideBarButtons;
    UIButton * _selectedButton;
    NSInteger _currentBtnIndex;
    UIScrollView *_scrollView;
}

@end

@implementation DYSlideView

- (void)dealloc{
    _scrollView = nil;
    _selectedButton = nil;
    _slideBarButtons = nil;
    _slider = nil;
    _slideBar = nil;
    _indexForDefaultItem = nil;
    _slideBarColor = nil;
    _sliderColor = nil;
    _buttonNormalColor = nil;
    _buttonSelectedColor = nil;
    _buttonTitleFont = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupForInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupForInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupForInitialization];
    }
    return self;
}

- (void)setupForInitialization {
    _slideBarColor = [UIColor lightGrayColor];
    _sliderColor = [UIColor redColor];;
    _buttonNormalColor = [UIColor whiteColor];
    _buttonSelectedColor = [UIColor blackColor];
    _sliderScale = 1.f;
    _slideBarHeight = 50.f;
    _sliderHeight = 4.f;
    _buttonTitleFont = [UIFont systemFontOfSize:16.f];
    _scrollViewBounces = YES;
    _scrollEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_slideBarButtons) {
        _numberOfViewControllers = [self.delegate DY_numberOfViewControllersInSlideView];
        [self addSlideBar];
        [self addScrollView];
        if (_indexForDefaultItem && [_slideBarButtons count] > [_indexForDefaultItem integerValue]) {
            UIButton * button = [_slideBarButtons objectAtIndex:[_indexForDefaultItem integerValue]];
            [self updateSelectedButton:button];
            [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * button.tag, 0) animated:NO];
        } else {
            [self updateSelectedButton:nil];
        }
        [_selectedButton setTitleColor:_buttonSelectedColor forState:UIControlStateNormal];
    }
}

- (void)addSlideBar {
    if (!_slideBar) {
        _slideBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _slideBarHeight)];
        [_slideBar setBackgroundColor:_slideBarColor];
        [self addSubview:_slideBar];
    }
    [self addButtons];
    [self addSlider];
}

- (void)addButtons {
    _slideBarButtons = [NSMutableArray array];
    for (NSInteger i = 0; i < _numberOfViewControllers; i++) {
        
        CGFloat width = self.bounds.size.width / _numberOfViewControllers;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake( width * i, 5, width, 35)];
        [button setTag:i];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setFont:_buttonTitleFont];
        [button setTitleColor:_buttonNormalColor forState:UIControlStateNormal];
        [button setTitle:[_delegate DY_titleForViewControllerAtIndex:i]?:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_slideBarButtons addObject:button];
        [_slideBar addSubview:button];
    }
}

- (void)addSlider {
    if (!_slider) {
        CGFloat buttonWidth = self.bounds.size.width / _numberOfViewControllers;
        CGFloat sliderWidth = buttonWidth * _sliderScale;
        
        _slider = [[UIView alloc] initWithFrame:CGRectMake((buttonWidth - sliderWidth)/2, _slideBarHeight-_sliderHeight, sliderWidth, _sliderHeight)];
        [_slider setBackgroundColor:_sliderColor];
        [_slideBar addSubview:_slider];
    }
}

- (void)addScrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setFrame:CGRectMake(0, _slideBarHeight, self.bounds.size.width, self.bounds.size.height - _slideBarHeight)];
        [_scrollView setDirectionalLockEnabled:YES];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * _numberOfViewControllers, 0)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:_scrollViewBounces];
        [_scrollView setScrollEnabled:_scrollEnabled];
        
        [self addSubview:_scrollView];
        
        for (NSInteger i = 0; i < _numberOfViewControllers; i++ ) {
            UIViewController * vc = [_delegate DY_viewControllerAtIndex:i];
            if (vc) {
                CGRect rect = _scrollView.bounds;
                rect.origin.x = self.bounds.size.width * i;
                [vc.view setFrame:rect];
                [_scrollView addSubview:vc.view];
            }
        }
    }
}

- (void)buttonClicked:(UIButton *)button {
    [self updateSelectedButton:button];
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * button.tag, 0) animated:YES];
}

- (void)updateSelectedButton:(UIButton *)button{
    if (button == nil && [_slideBarButtons count] > 0) {
        button = [_slideBarButtons firstObject];
    }
    if (!(_selectedButton && [_slideBarButtons indexOfObject:_selectedButton] == [button tag])) {
        _selectedButton = button;
        if (_delegate && [_delegate respondsToSelector:@selector(DY_didSelectButtonAtIndex:)]) {
            [self.delegate DY_didSelectButtonAtIndex:[_selectedButton tag]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    
    CGFloat buttonWidth = self.bounds.size.width / _numberOfViewControllers;
    CGFloat sliderWidth = buttonWidth * _sliderScale;
    CGRect rect = _slider.frame;
    rect.origin.x = (contentOffset.x/self.bounds.size.width) * buttonWidth + (buttonWidth - sliderWidth)/2;
    [_slider setFrame:rect];
    
    CGFloat ratio = contentOffset.x/self.bounds.size.width;
    NSInteger index = (NSInteger)ratio;
    if (ratio - (NSInteger)ratio >= 0.5) {
        index += 1;
    }
    
    if (index < _numberOfViewControllers && _currentBtnIndex != index) {
        _currentBtnIndex = index;
        for (UIButton *button in _slideBarButtons) {
            if ([_slideBarButtons indexOfObject:button] == _currentBtnIndex) {
                [[_slideBarButtons objectAtIndex:_currentBtnIndex] setTitleColor:_buttonSelectedColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:_buttonNormalColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateSelectedButton:[_slideBarButtons objectAtIndex:_currentBtnIndex]];
}

@end
