# DYSlideView

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DYSlideView.svg)](https://img.shields.io/cocoapods/v/DYSlideView.svg)
[![Platform](https://img.shields.io/cocoapods/p/DYSlideView.svg)](http://cocoadocs.org/docsets/DYSlideView)
[![Twitter](https://img.shields.io/badge/twitter-@DwarvenYang-blue.svg)](http://twitter.com/DwarvenYang)
[![License](https://img.shields.io/github/license/Dwarven/DYSlideView.svg)](https://img.shields.io/github/license/Dwarven/DYSlideView.svg)

An iOS tabbed slide view.

#Preview
![DYSlideView Demo Gif](https://raw.githubusercontent.com/Dwarven/DYSlideView/master/demo.gif)

# Podfile
To integrate DYSlideView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DYSlideView'
```

# How to use 

```obj-c
#import "DYSlideView.h"

//init and setup DYSlideView
DYSlideView *slideView = [[DYSlideView alloc] init];
[slideView setFrame:self.view.bounds];
    
slideView.slideBarColor = [UIColor lightGrayColor];
slideView.slideBarHeight = 50;
    
slideView.sliderColor = [UIColor redColor];
slideView.sliderHeight = 2;
slideView.sliderScale = 0.6;
    
slideView.buttonNormalColor = [UIColor yellowColor];
slideView.buttonSelectedColor = [UIColor blackColor];
slideView.buttonTitleFont = [UIFont boldSystemFontOfSize:16.f];
    
slideView.scrollViewBounces = YES;
slideView.scrollEnabled = YES;
    
slideView.delegate = self;
[self.view addSubview:slideView];

//add delegate
@interface YourViewController () <DYSlideViewDelegate>
@end

//implement delegate
@required
- (NSInteger)DY_numberOfViewControllersInSlideView;
- (nonnull NSString *)DY_titleForViewControllerAtIndex:(NSInteger)index;
//You need to add the ViewController to YourViewController's childViewControllers.
- (nonnull UIViewController *)DY_viewControllerAtIndex:(NSInteger)index;

@optional
- (void)DY_didSelectButtonAtIndex:(NSInteger)index;
```


