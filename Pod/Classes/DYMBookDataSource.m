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
    
    NSUInteger          _currentChapterIndex;
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

-(void)navigate:(BOOL)forward completion:(dispatch_block_t)completion {
    forward ? _currentChapterIndex++ : _currentChapterIndex--;
    
    _currentChapterIndex = MIN(_currentChapterIndex, _chapters.count - 1);
    _currentChapterIndex = MAX(_currentChapterIndex, 0);
    
    [self preloadChapters:completion];
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
