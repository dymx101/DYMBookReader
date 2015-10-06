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
    
    NSDictionary            *_bookDic;
}

@end


@implementation DYMBookReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    // Datasource
    _datasource = [DYMBookPageDatasource new];
    NSString *content;
    
    if ([_bookPath rangeOfString:@".plist"].location != NSNotFound) {
        
        _bookDic = [NSDictionary dictionaryWithContentsOfFile:_bookPath];
        id chapter = _bookDic[@"chapterArrArr"][0][0];
        content = chapter[@"chapterContent"];
        
    } else if ([_bookPath rangeOfString:@".txt"].location != NSNotFound) {
        content = [DYMBookProvider bookWithTxtFilePath:_bookPath];
    }
    
    if (content == nil) {
        return;
    }
    
    CGSize contentSize = CGSizeMake(self.view.frame.size.width - 20, self.view.frame.size.height - 30);
    
    _datasource.content = content;
    _datasource.contentSize = contentSize;
    _datasource.font = [UIFont systemFontOfSize:20];
    _datasource.textColor = [UIColor whiteColor];
    _datasource.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [indicatorView startAnimating];
    
    [_datasource refresh:^{
        
        [indicatorView removeFromSuperview];
        
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
