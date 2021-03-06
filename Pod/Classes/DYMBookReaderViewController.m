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


@interface DYMBookReaderViewController ()
<UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
//    DYMBookChapter          *_currentChapter;
    
    UIPageViewController    *_pageVC;
    
//    DYMBook                 *_book;
    
    NSUInteger              _bookChapterIndex;
    
    DYMBookTimer            *_bookTimer;
    
    DYMBookPageStyle        *_pageStyle;
    
    DYMBookDataSource       *_dateSource;
    
    DYMPageTapHandler       _pageTapHandler;
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
    
    
    // Creating page view controller
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
    
    
    /// page tap handler
    __weak typeof(self) weakSelf = self;
    _pageTapHandler = ^void(EDYMBookPageArea pageArea, DYMBookPageVC *page) {
        __strong typeof(self) strongSelf = weakSelf;
        if (pageArea == kDYMBookPageAreaMiddle) {
            NSLog(@"show/hide toobar...");
        } else if (pageArea == kDYMBookPageAreaLeft) {
            NSLog(@"go previous...");
        } else if (pageArea == kDYMBookPageAreaRight) {
            NSLog(@"go next...");
        }
    };
    
    // Load the book
    if (_plistFileName) {
        
        _dateSource = [[DYMBookDataSource alloc] initWithPlistFileName:_plistFileName pageStyle:_pageStyle];
        
        __weak typeof(self) weakSelf = self;
        [_dateSource load:^{
            __strong typeof(self) strongSelf = weakSelf;
            // first page
            DYMBookPageVC *pageVC = [[strongSelf->_dateSource currentChapter] firstPage];
            if (pageVC) {
                pageVC.pageTapHandler = _pageTapHandler;
                pageVC.transitionStyle = self->_pageVC.transitionStyle;
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
    
    DYMBookPageVC *vc = [self pageVC:NO];
    
//    NSLog(@"Before:--->%@", vc);
    
    return vc;

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    DYMBookPageVC *vc = [self pageVC:YES];

//    NSLog(@"After:--->%@", vc);
    
    return vc;
}

-(DYMBookPageVC *)pageVC:(BOOL)forward {
    
    DYMBookPageVC *pageVC = [_dateSource getPage:forward];
    pageVC.pageTapHandler = _pageTapHandler;
    pageVC.transitionStyle = _pageVC.transitionStyle;
    
    return pageVC;
}

#pragma mark - UIPageViewControllerDelegate
//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
//    DYMBookPageVC *vc = pendingViewControllers.firstObject;
//    NSLog(@"Will show: %@", [vc valueForKey:@"_currentIndex"]);
//}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    DYMBookPageVC *vc = pageViewController.viewControllers.firstObject;
    
    [_dateSource setCurrentChapter:vc.chapter];
    [[_dateSource currentChapter] didShowPageVC:vc];
    
//    NSLog(@"Current:--->%@", vc);
}

@end
