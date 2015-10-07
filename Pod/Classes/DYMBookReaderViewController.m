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
#import "DYMBookDataSource.h"

#import <Masonry/Masonry.h>


@interface DYMBookReaderViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
//    DYMBookChapter          *_currentChapter;
    
    UIPageViewController    *_pageVC;
    
//    DYMBook                 *_book;
    
    NSUInteger              _bookChapterIndex;
    
    DYMBookTimer            *_bookTimer;
    
    DYMBookPageStyle        *_pageStyle;
    
    DYMBookDataSource       *_dateSource;
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
    _pageStyle.contentSize = CGSizeMake(self.view.frame.size.width - (_pageEdgeInset.left + _pageEdgeInset.right)
                                                      , self.view.frame.size.height - (_pageEdgeInset.top + _pageEdgeInset.bottom));
    
    
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
        
        _dateSource = [[DYMBookDataSource alloc] initWithPlistFileName:_plistFileName pageStyle:_pageStyle];
        
        __weak typeof(self) weakSelf = self;
        [_dateSource load:^{
            __strong typeof(self) strongSelf = weakSelf;
            // first page
            DYMBookPageVC *pageVC = [[strongSelf->_dateSource currentChapter] firstPage];
            if (pageVC) {
                [_pageVC setViewControllers:@[pageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }
            
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
    DYMBookChapter *currentChapter = [_dateSource currentChapter];
    NSInteger index = forward ? currentChapter.currentPageIndex + 1 : currentChapter.currentPageIndex - 1;
    DYMBookPageVC *vc = [currentChapter pageAtIndex:index];
    return vc;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    DYMBookPageVC *vc = pendingViewControllers.firstObject;
    NSLog(@"Will show: %@", [vc valueForKey:@"_currentIndex"]);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    DYMBookPageVC *vc = pageViewController.viewControllers.firstObject;
    
    [[_dateSource currentChapter] didShowPageVC:vc];
}

@end
