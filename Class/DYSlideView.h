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
- (nonnull NSArray *)DY_titlesForViewControllersInSlideView;
- (nonnull NSArray *)DY_viewControllersInSlideView;

@optional
- (void)DY_didSelectButtonAtIndex:(NSInteger)index;

@end


@interface DYSlideView : UIView

@property (nonatomic, strong, nonnull) id <DYSlideViewDelegate> delegate;

@property (strong, nonatomic, nonnull) UIColor *slideBarColor;
@property (nonatomic) CGFloat slideBarHeight;

@property (strong, nonatomic, nonnull) UIColor *sliderColor;
@property (nonatomic) CGFloat sliderHeight;
@property (nonatomic) CGFloat sliderScale;

@property (strong, nonatomic, nonnull) UIColor *buttonNormalColor;
@property (strong, nonatomic, nonnull) UIColor *buttonSelectedColor;
@property (strong, nonatomic, nonnull) UIFont *buttonTitleFont;

@property (nonatomic) BOOL scrollViewBounces;


@end
