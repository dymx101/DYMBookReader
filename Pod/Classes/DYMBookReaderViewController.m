//
//  DYMBookReaderViewController.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookReaderViewController.h"
#import "DYMBookProvider.h"
#import "DYMBookChapter.h"
#import "DYMBookPageVC.h"
#import "DYMBookUtility.h"
#import "DYMBookTimer.h"

#import <Masonry/Masonry.h>


@interface DYMBookReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    DYMBookChapter          *_currentChapter;
    
    UIPageViewController    *_pageVC;
    
//    NSInteger               _currentPageIndex;
    
    DYMBook                 *_book;
    
    NSUInteger              _bookChapterIndex;
    
    DYMBookTimer            *_bookTimer;
    
    DYMBookPageStyle        *_pageStyle;
}

@end


@implementation DYMBookReaderViewController

-(void)dealloc {
    [_bookTimer stop];
    _bookTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Timer
    _bookTimer = [DYMBookTimer new];
    [_bookTimer start];
    
    self.view.backgroundColor = [UIColor colorWithRed:80/255.0 green:92/255.0 blue:89/255.0 alpha:1];
    
    // Page Style
    _pageStyle = [DYMBookPageStyle new];
    if (_customFontName) {
        _pageStyle.font = [DYMBookUtility customFontWithFileName:_customFontName Size:16];
    } else {
        _pageStyle.font = [UIFont systemFontOfSize:16];
    }
    
    _pageStyle.textColor = [UIColor colorWithWhite:0.85 alpha:0.7];
    _pageStyle.backgroundColor = self.view.backgroundColor;
    _pageStyle.pageEdgeInset = _pageEdgeInset;
    
    
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(void)loadChapterAtIndex:(NSUInteger)index {
    
    NSString *chapterContent = [_book chapterContentAtIndex:index];
    
    // Datasource
    _currentChapter = [DYMBookChapter new];
    _currentChapter.content = chapterContent;
    _currentChapter.bookName = _book.data[@"title"];
    _currentChapter.chapterTitle = [_book chapterTitleAtIndex:index];
    
    _currentChapter.contentSize = CGSizeMake(self.view.frame.size.width - (_pageEdgeInset.left + _pageEdgeInset.right)
                                         , self.view.frame.size.height - (_pageEdgeInset.top + _pageEdgeInset.bottom));
    
    _currentChapter.pageStyle = _pageStyle;
    
    // Refresh datesource
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [indicatorView startAnimating];
    
    [_currentChapter refresh:^{
        
        [indicatorView removeFromSuperview];
        
        // first page
        DYMBookPageVC *pageVC = [_currentChapter firstPage];
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
    NSInteger index = forward ? _currentChapter.currentPageIndex + 1 : _currentChapter.currentPageIndex - 1;
    DYMBookPageVC *vc = [_currentChapter pageAtIndex:index];
    return vc;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    DYMBookPageVC *vc = pendingViewControllers.firstObject;
    NSLog(@"Will show: %@", [vc valueForKey:@"_currentIndex"]);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    DYMBookPageVC *vc = pageViewController.viewControllers.firstObject;
    
    [_currentChapter didShowPageVC:vc];
    
    NSLog(@"Did show:%@", @(_currentChapter.currentPageIndex));
}

@end
