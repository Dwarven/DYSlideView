//
//  DYSlideView.m
//  DYSlideView
//
//  Created by Dwarven on 16/4/18.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "DYSlideView.h"

@interface DYSlideView () <UIScrollViewDelegate>
{
    NSInteger _numberOfViewControllers;
    UIView * _slideBar;
    UIView * _slider;
    NSMutableArray *_slideBarButtons, *_addedControllers;
    UIButton * _selectedButton;
    UIScrollView *_scrollView;
    BOOL _initializating;
}

@end

@implementation DYSlideView

- (void)dealloc
{
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

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupForInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupForInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupForInitialization];
    }
    return self;
}

- (void)setupForInitialization
{
    _initializating = YES;
    _numberOfViewControllers = NSNotFound;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( _initializating )
    {
        _numberOfViewControllers = [self.delegate DY_numberOfViewControllersInSlideView];
        _slideBar = [[UIView alloc] initWithFrame:CGRectZero];
        [_slideBar setBackgroundColor:_slideBarColor];
        [self addSubview:_slideBar];
    }
    [_slideBar setFrame:CGRectMake(0, 0, self.bounds.size.width, _slideBarHeight)];
    
    if ( _initializating )
    {
        _slideBarButtons = [NSMutableArray array];
        for (NSInteger i = 0; i < _numberOfViewControllers; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectZero];
            [button setTag:i];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button setAttributedTitle:[_delegate DY_attributedtitleForViewControllerAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_slideBarButtons addObject:button];
            [_slideBar addSubview:button];
        }
    }
    
    for (NSInteger i = 0; i < _numberOfViewControllers; i++)
    {
        UIButton *button = _slideBarButtons[i];
        CGFloat width = self.bounds.size.width / _numberOfViewControllers;
        [button setFrame:CGRectMake( width * i, 5, width, 35)];
    }
    
    CGFloat buttonWidth = self.bounds.size.width / _numberOfViewControllers;
    CGFloat sliderWidth = buttonWidth * _sliderScale;
    
    if ( _initializating )
    {
        _slider = [[UIView alloc] initWithFrame:CGRectZero];
        [_slideBar addSubview:_slider];
        [_slider setBackgroundColor:_sliderColor];
    }
    [_slider setFrame:CGRectMake((buttonWidth - sliderWidth)/2, _slideBarHeight-_sliderHeight, sliderWidth, _sliderHeight)];
    
    if ( _initializating )
    {
        _addedControllers = [[NSMutableArray alloc] init];
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setFrame:CGRectZero];
        [_scrollView setDirectionalLockEnabled:YES];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:_scrollViewBounces];
        [_scrollView setScrollEnabled:_scrollEnabled];
        
        [self addSubview:_scrollView];
        
        for (NSInteger i = 0; i < _numberOfViewControllers; i++ )
        {
            UIViewController * vc = [_delegate DY_viewControllerAtIndex:i];
            [_addedControllers addObject:vc ? vc : [NSNull null]];
            [_scrollView addSubview:vc.view];
        }
    }
    [_scrollView setFrame:CGRectMake(0, _slideBarHeight, self.bounds.size.width, self.bounds.size.height - _slideBarHeight)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * _numberOfViewControllers, 0)];
    
    for (NSInteger i = 0; i < _numberOfViewControllers; i++ )
    {
        if ( [_addedControllers[i] isEqual:[NSNull null]] ) continue;
        UIViewController *vc = _addedControllers[i];
        
        CGRect rect = _scrollView.bounds;
        rect.origin.x = self.bounds.size.width * i;
        [vc.view setFrame:rect];
    }
    
    if (_indexForDefaultItem && [_slideBarButtons count] > [_indexForDefaultItem integerValue])
    {
        UIButton * button = [_slideBarButtons objectAtIndex:[_indexForDefaultItem integerValue]];
        [self updateSelectedButton:button];
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * button.tag, 0) animated:NO];
    }
    else
    {
        [self updateSelectedButton:nil];
    }
    
    if ( _initializating )
    {
        [[_slideBarButtons objectAtIndex:_currentSelectedIndex] setAttributedTitle:[_delegate DY_attributedtitleForViewControllerAtIndex:_currentSelectedIndex] forState:UIControlStateNormal];
    }

    _initializating = NO;
}

- (void)buttonClicked:(UIButton *)button
{
    [self updateSelectedButton:button];
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * button.tag, 0) animated:YES];
}

- (void)updateSelectedButton:(UIButton *)button
{
    if (button == nil && [_slideBarButtons count] > 0)
    {
        button = [_slideBarButtons firstObject];
    }
    if (!(_selectedButton && [_slideBarButtons indexOfObject:_selectedButton] == [button tag]))
    {
        _selectedButton = button;
        if (_delegate && [_delegate respondsToSelector:@selector(DY_didSelectButtonAtIndex:)])
        {
            [self.delegate DY_didSelectButtonAtIndex:[_selectedButton tag]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    
    CGFloat buttonWidth = self.bounds.size.width / _numberOfViewControllers;
    CGFloat sliderWidth = buttonWidth * _sliderScale;
    CGRect rect = _slider.frame;
    rect.origin.x = (contentOffset.x/self.bounds.size.width) * buttonWidth + (buttonWidth - sliderWidth)/2;
    [_slider setFrame:rect];
    
    CGFloat ratio = contentOffset.x/self.bounds.size.width;
    NSInteger index = (NSInteger)ratio;
    if (ratio - (NSInteger)ratio >= 0.5)
    {
        index += 1;
    }
    
    if (index < _numberOfViewControllers && _currentSelectedIndex != index)
    {
        _currentSelectedIndex = index;
        for ( NSInteger b = 0; b < [_slideBarButtons count]; b++)
        {
            [_slideBarButtons[b] setAttributedTitle:[_delegate DY_attributedtitleForViewControllerAtIndex:b] forState:UIControlStateNormal];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateSelectedButton:[_slideBarButtons objectAtIndex:_currentSelectedIndex]];
}

@end
