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
    [slideView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [slideView setFrame:self.view.bounds];
    
    slideView.slideBarColor = [UIColor lightGrayColor];
    slideView.slideBarHeight = 50;
    
    slideView.sliderColor = [UIColor redColor];
    slideView.sliderHeight = 2;
//    slideView.sliderScale = 0.6;
    
    slideView.scrollViewBounces = YES;
    
    slideView.indexForDefaultItem = @0;
    
    slideView.delegate = self;
    [self.view addSubview:slideView];
    
}

- (NSInteger)DY_numberOfViewControllersInSlideView {
    return 4;
}

- (NSAttributedString *)DY_attributedtitleForViewControllerAtIndex:(NSInteger)index
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Tab%li",index] attributes:nil];
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
