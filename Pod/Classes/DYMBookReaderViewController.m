//
//  DYMBookReaderViewController.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookReaderViewController.h"
#import "DYMBookProvider.h"
#import <Masonry/Masonry.h>

@interface DYMBookReaderViewController () <UIPageViewControllerDataSource> {
    NSString                *_content;
    UIPageViewController    *_pageVC;
}

@end


#pragma mark -  UIPageViewControllerDataSource
@implementation DYMBookReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    _content = [DYMBookProvider loadBookAtURL:_bookURL];
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.dataSource = self;
    _pageVC.view.backgroundColor = [UIColor redColor];
    
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_pageVC didMoveToParentViewController:self];
    
    [_pageVC setViewControllers:@[[self _randomVC]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return [self _randomVC];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self _randomVC];
}

-(UIViewController *)_randomVC {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor colorWithWhite:(arc4random() % 128 + 128) / 255.0 alpha:1];
    
    return vc;
}

@end
