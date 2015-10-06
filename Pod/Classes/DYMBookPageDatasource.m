//
//  DYMBookPageDatasource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookPageDatasource.h"

@interface DYMBookPageDatasource () {
    NSTextStorage       *_storage;
    NSLayoutManager     *_layoutManager;
    
    NSMutableArray      *_pageVCs;
}



@end



@implementation DYMBookPageDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageVCs = [NSMutableArray array];
    }
    return self;
}

-(void)setContent:(NSString *)content withContentSize:(CGSize)contentSize {
    
    _content = content;
    _contentSize = contentSize;
    
    _storage = [[NSTextStorage alloc] initWithString:_content];
    _layoutManager = [[NSLayoutManager alloc] init];
    [_storage addLayoutManager:_layoutManager];
    
    //
    NSRange range = NSMakeRange(0, 0);
    NSUInteger  containerIndex = 0;
    [_pageVCs removeAllObjects];
    
    while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
        
        CGSize shorterSize = CGSizeMake(_contentSize.width, _contentSize.height - 30);
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:shorterSize];
        [_layoutManager addTextContainer:container];
        
        DYMBookPageVC *pageVC = [DYMBookPageVC new];
        [pageVC setTextContainer:container contentSize:_contentSize];
        [_pageVCs addObject:pageVC];
        
        range = [_layoutManager glyphRangeForTextContainer:container];
        containerIndex++;
    }
}

-(DYMBookPageVC *)firstPage {
    return _pageVCs.firstObject;
}

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < _pageVCs.count) {
        return _pageVCs[index];
    }
    
    return nil;
}

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC {
    return [_pageVCs indexOfObject:pageVC];
}


@end
