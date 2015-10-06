//
//  DYMBookPageDatasource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookPageDatasource.h"
#import "DYMBookPagesCache.h"
#import "DYMBookUtility.h"

@interface DYMBookPageDatasource () {
    
    NSTextStorage           *_storage;
    
    NSLayoutManager         *_layoutManager;
    
    DYMBookPagesCache       *_pagesCache;
}



@end



@implementation DYMBookPageDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pagesCache = [DYMBookPagesCache new];
    }
    return self;
}

-(void)refresh:(dispatch_block_t)block {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_content];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (_font) {
        [attributes setObject:_font forKey:NSFontAttributeName];
    }
    
    if (_textColor) {
        [attributes setObject:_textColor forKey:NSForegroundColorAttributeName];
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:_font.lineHeight * 0.7];
    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
    
    [attributes setObject:@(1.2) forKey:NSKernAttributeName];
    
    if (attributes.allKeys.count > 0) {
        [attrStr setAttributes:attributes range:NSMakeRange(0, _content.length)];
    }
    
    _storage = [[NSTextStorage alloc] initWithAttributedString:attrStr];
    _layoutManager = [[NSLayoutManager alloc] init];
    [_storage addLayoutManager:_layoutManager];
    
    
    //
    [DYMBookUtility doAsync:^{
        
        NSRange range = NSMakeRange(0, 0);
        NSUInteger  containerIndex = 0;
        
        NSLog(@"begin add textContainers...");
        while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
            
            CGSize shorterSize = CGSizeMake(_contentSize.width, _contentSize.height - _font.lineHeight);
            NSTextContainer *container = [[NSTextContainer alloc] initWithSize:shorterSize];
            [_layoutManager addTextContainer:container];
            
            range = [_layoutManager glyphRangeForTextContainer:container];
            containerIndex++;
        }
        NSLog(@"end add textContainers...");
        
    } completion:block];
}

-(DYMBookPageVC *)firstPage {
    
    NSTextContainer *container = _layoutManager.textContainers.firstObject;
    
    DYMBookPageVC *vc = [_pagesCache dequeuePageForContainer:container contentSize:_contentSize pageEdgeInset:_pageEdgeInset];
    vc.view.backgroundColor = _backgroundColor;

    return vc;
}

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < _layoutManager.textContainers.count) {
        
        NSTextContainer *container = _layoutManager.textContainers[index];
        DYMBookPageVC *vc = [_pagesCache dequeuePageForContainer:container contentSize:_contentSize pageEdgeInset:_pageEdgeInset];
        vc.view.backgroundColor = _backgroundColor;
        return vc;
    }
    
    return nil;
}

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC {
    return [_layoutManager.textContainers indexOfObject:pageVC.textContainer];
}


@end
