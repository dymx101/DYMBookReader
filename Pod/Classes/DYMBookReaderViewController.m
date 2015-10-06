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
#import "DYMBookUtility.h"

#import <Masonry/Masonry.h>


@interface DYMBookReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    DYMBookPageDatasource   *_datasource;
    
    UIPageViewController    *_pageVC;
    
    NSInteger               _currentPageIndex;
    
    DYMBook                 *_book;
    
    NSUInteger              _bookChapterIndex;
}

@end


@implementation DYMBookReaderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:80/255.0 green:92/255.0 blue:89/255.0 alpha:1];
    
    // Page view controller
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.dataSource = self;
    _pageVC.delegate = self;
    _pageVC.view.backgroundColor = self.view.backgroundColor;
    
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_pageVC didMoveToParentViewController:self];
    
    
    // Load the book
    if (_plistFileName) {
        
        _book = [DYMBookProvider bookWithPlistFileName:_plistFileName];
        
        __weak typeof(self) weakSelf = self;
        [_book load:^{
            [weakSelf loadChapterAtIndex:0];
        }];
        
    }
}


-(void)loadChapterAtIndex:(NSUInteger)index {
    NSString *chapterContent = [_book chapterContentAtIndex:index];
    
    // Datasource
    _datasource = [DYMBookPageDatasource new];
    _datasource.content = chapterContent;
    _datasource.contentSize = CGSizeMake(self.view.frame.size.width - (_pageEdgeInset.left + _pageEdgeInset.right)
                                         , self.view.frame.size.height - (_pageEdgeInset.top + _pageEdgeInset.bottom));
    
    if (_customFontName) {
        _datasource.font = [DYMBookUtility customFontWithFileName:_customFontName Size:16];
    } else {
        _datasource.font = [UIFont systemFontOfSize:16];
    }
    
    _datasource.textColor = [UIColor colorWithWhite:0.85 alpha:0.7];
    _datasource.backgroundColor = self.view.backgroundColor;
    _datasource.pageEdgeInset = _pageEdgeInset;
    
    // Refresh datesource
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [indicatorView startAnimating];
    
    [_datasource refresh:^{
        
        [indicatorView removeFromSuperview];
        
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
    NSInteger index = forward ? _currentPageIndex + 1 : _currentPageIndex - 1;
    DYMBookPageVC *vc = [_datasource pageAtIndex:index];
    return vc;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    DYMBookPageVC *vc = pageViewController.viewControllers.firstObject;
    
    _currentPageIndex = [_datasource indexOfPageVC:vc];
}

@end
