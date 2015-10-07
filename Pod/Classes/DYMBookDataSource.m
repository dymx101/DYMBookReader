//
//  DYMBookDataSource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/7.
//
//

#import "DYMBookDataSource.h"
#import "DYMBook.h"
#import "DYMBookProvider.h"
#import "DYMBookChapter.h"

@interface DYMBookDataSource () {
    DYMBook             *_book;
    NSMutableArray      *_chapters;
    
    NSInteger          _currentChapterIndex;
}

@end

@implementation DYMBookDataSource

-(instancetype)initWithPlistFileName:(NSString *)plistFileName pageStyle:(DYMBookPageStyle *)pageStyle {
    
    self = [super init];
    if (self) {
        _plistFileName = plistFileName;
        _pageStyle = pageStyle;
        _chapters = [NSMutableArray array];
    }
    return self;
}

-(void)load:(dispatch_block_t)completionBlock {
    
    _book = [DYMBookProvider bookWithPlistFileName:_plistFileName];
    
    [_chapters removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [_book load:^{
        
        __strong typeof(self) strongSelf = weakSelf;
        NSArray *chapters = strongSelf->_book.chapters;
        for (id chapterDic in chapters) {
            DYMBookChapter *chapterObject = [DYMBookChapter new];
            chapterObject.content = chapterDic[@"chapterContent"];
            chapterObject.bookName = _book.data[@"title"];
            chapterObject.chapterTitle = chapterDic[@"chapterTitle"];
            chapterObject.pageStyle = _pageStyle;

            [strongSelf->_chapters addObject:chapterObject];
        }
        
        // Preload
        [strongSelf loadChapterAtIndex:_currentChapterIndex completion:^{
            
            if (completionBlock) {
                completionBlock();
            }
            
            [strongSelf loadChapterAtIndex:_currentChapterIndex + 1 completion:nil];
            [strongSelf loadChapterAtIndex:_currentChapterIndex - 1 completion:nil];
        }];
        
        
    }];
}

-(void)loadChapterAtIndex:(NSUInteger)index completion:(dispatch_block_t)completionBlock {
    
    BOOL needRefresh = NO;
    
    if (index < _chapters.count) {
        DYMBookChapter *chapter = _chapters[index];
        if (chapter.status != kDYMBookChapterReady) {
            needRefresh = YES;
            [chapter refresh:completionBlock];
            return;
        }
    }
    
    if (!needRefresh && completionBlock) {
        completionBlock();
    }
}

-(DYMBookChapter *)currentChapter {
    DYMBookChapter *chapter = _chapters[_currentChapterIndex];
    
    return chapter;
}

-(DYMBookPageVC *)getPage:(BOOL)forward {
    DYMBookChapter *currentChapter = [self currentChapter];
    NSInteger index = forward ? currentChapter.currentPageIndex + 1 : currentChapter.currentPageIndex - 1;
    DYMBookPageVC *vc = [currentChapter pageAtIndex:index];
    
    if (vc == nil) {
        vc = [self navigate:forward completion:nil];
    }
    
    return vc;
}

-(DYMBookPageVC *)navigate:(BOOL)forward completion:(dispatch_block_t)completion {
    
    forward ? _currentChapterIndex++ : _currentChapterIndex--;
    
    NSInteger lastIndex = _chapters.count - 1;
    if (_currentChapterIndex > lastIndex) {
        _currentChapterIndex = lastIndex;
        return nil;
    } else if (_currentChapterIndex < 0) {
        _currentChapterIndex = 0;
        return nil;
    }
    
    DYMBookPageVC *pageVC;
    
    if (forward) {
        pageVC = [[self currentChapter] goToFirstPage];
    } else {
        pageVC = [[self currentChapter] goToLastPage];
    }
    
    [self preloadChapters:completion];
    
    return pageVC;
}

-(void)preloadChapters:(dispatch_block_t)completion {
    [self loadChapterAtIndex:_currentChapterIndex completion:^{
        
        if (completion) {
            completion();
        }
        
        [self loadChapterAtIndex:_currentChapterIndex + 1 completion:nil];
        [self loadChapterAtIndex:_currentChapterIndex - 1 completion:nil];
    }];

}

@end
