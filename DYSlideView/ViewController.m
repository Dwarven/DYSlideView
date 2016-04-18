//
//  ViewController.m
//  DYSlideView
//
//  Created by Dwarven on 16/4/18.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "ViewController.h"
#import "DYSlideView.h"

@interface ViewController () <DYSlideViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    slideView.delegate = self;
    [self.view addSubview:slideView];
    
}

- (NSInteger)DY_numberOfViewControllersInSlideView {
    return 4;
}

- (NSString *)DY_titleForViewControllerAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"Tab%li",index];
}

- (UIViewController *)DY_viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [self vcWithBackgroundColor:[UIColor whiteColor]];
            break;
            
        case 1:
            return [self vcWithBackgroundColor:[UIColor grayColor]];
            break;
            
        case 2:
            return [self vcWithBackgroundColor:[UIColor darkGrayColor]];
            break;
            
        default:
            return [self vcWithBackgroundColor:[UIColor blackColor]];
            break;
    }
}

- (UIViewController *)vcWithBackgroundColor:(UIColor *)backgroundColor {
    UIViewController * vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = backgroundColor;
    return vc;
}

- (void)DY_didSelectButtonAtIndex:(NSInteger)index {
    NSLog(@"%s %li",__FUNCTION__ ,index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
