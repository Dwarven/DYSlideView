//
//  DYSlideView.h
//  DYSlideView
//
//  Created by Dwarven on 16/4/18.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DYSlideViewDelegate <NSObject>

@required
- (NSInteger)DY_numberOfViewControllersInSlideView;
- (NSAttributedString *)DY_attributedtitleForViewControllerAtIndex:(NSInteger)index;
- (UIViewController *)DY_viewControllerAtIndex:(NSInteger)index;

@optional
- (void)DY_didSelectButtonAtIndex:(NSInteger)index;

@end


@interface DYSlideView : UIView

@property (nonatomic, weak) id <DYSlideViewDelegate> delegate;

@property (strong, nonatomic) NSNumber *indexForDefaultItem;
@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;

@property (strong, nonatomic) UIColor *slideBarColor;
@property (nonatomic) CGFloat slideBarHeight;

@property (strong, nonatomic) UIColor *sliderColor;
@property (nonatomic) CGFloat sliderHeight;
@property (nonatomic) CGFloat sliderScale;

@property (nonatomic) BOOL scrollViewBounces;
@property (nonatomic) BOOL scrollEnabled;


@end
