//
//  DYMBookReaderViewController.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookReaderViewController.h"
#import "DYMBookProvider.h"
#import "DYMBookPageDatasource.h"
#import "DYMBookPageVC.h"

#import <Masonry/Masonry.h>

@interface DYMBookReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    DYMBookPageDatasource   *_datasource;
    
    UIPageViewController    *_pageVC;
    
    NSInteger               _currentIndex;
}

@end


@implementation DYMBookReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Datasource
    _datasource = [DYMBookPageDatasource new];
    NSString *content = [DYMBookProvider loadBookAtURL:_bookURL];
    CGSize contentSize = CGSizeMake(self.view.frame.size.width - 20, self.view.frame.size.height - 30);
    
    _datasource.content = content;
    _datasource.contentSize = contentSize;
    _datasource.font = [UIFont systemFontOfSize:20];
    
    [_datasource refresh:^{
        
        // Page view controller
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        _pageVC.view.backgroundColor = [UIColor whiteColor];
        
        [self addChildViewController:_pageVC];
        [self.view addSubview:_pageVC.view];
        [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [_pageVC didMoveToParentViewController:self];
        
        // first page
        DYMBookPageVC *pageVC = [_datasource firstPage];
        if (pageVC) {
            
            [_pageVC setViewControllers:@[pageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        
    }];
}

#pragma mark -  UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return [self pageVC:NO];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self pageVC:YES];
}

-(DYMBookPageVC *)pageVC:(BOOL)forward {
    NSInteger index = forward ? _currentIndex + 1 : _currentIndex - 1;
    DYMBookPageVC *vc = [_datasource pageAtIndex:index];
    return vc;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    DYMBookPageVC *vc = pageViewController.viewControllers.firstObject;
    
    _currentIndex = [_datasource indexOfPageVC:vc];
}

@end
