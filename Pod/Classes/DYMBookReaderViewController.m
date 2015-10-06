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

@interface DYMBookReaderViewController () <UIPageViewControllerDataSource> {
    DYMBookPageDatasource   *_datasource;
    UIPageViewController    *_pageVC;
}

@end


#pragma mark -  UIPageViewControllerDataSource
@implementation DYMBookReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    _datasource = [DYMBookPageDatasource new];
    NSString *content = [DYMBookProvider loadBookAtURL:_bookURL];
    CGSize contentSize = CGRectInset(self.view.frame, 20, 20).size;
    [_datasource setContent:content withContentSize:contentSize];
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.dataSource = self;
    _pageVC.view.backgroundColor = [UIColor redColor];
    
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_pageVC didMoveToParentViewController:self];
    
    NSTextContainer *container = [_datasource navigateToTheBeginning];
    if (container) {
        DYMBookPageVC *vc = [[DYMBookPageVC alloc] initWithTextContainer:container contentSize:_datasource.contentSize];
        [_pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return [self pageVC:YES];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self pageVC:NO];
}

-(DYMBookPageVC *)pageVC:(BOOL)forward {
    NSTextContainer *container = [_datasource navigate:forward];
    if (container) {
        DYMBookPageVC *vc = [[DYMBookPageVC alloc] initWithTextContainer:container contentSize:_datasource.contentSize];
        return vc;
    }
    
    return nil;
}

@end
