//
//  DYMBookPageDatasource.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookPageDatasource.h"
#import "DYMBookPagesCache.h"

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
    
    if (attributes.allKeys.count > 0) {
        [attrStr setAttributes:attributes range:NSMakeRange(0, _content.length)];
    }
    
    _storage = [[NSTextStorage alloc] initWithAttributedString:attrStr];
    _layoutManager = [[NSLayoutManager alloc] init];
    [_storage addLayoutManager:_layoutManager];
    
    
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      
        NSRange range = NSMakeRange(0, 0);
        NSUInteger  containerIndex = 0;
        
        NSLog(@"begin add textContainers...");
        while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
            
            CGSize shorterSize = CGSizeMake(_contentSize.width, _contentSize.height - 30);
            NSTextContainer *container = [[NSTextContainer alloc] initWithSize:shorterSize];
            [_layoutManager addTextContainer:container];
            
            range = [_layoutManager glyphRangeForTextContainer:container];
            containerIndex++;
        }
        NSLog(@"end add textContainers...");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}

-(DYMBookPageVC *)firstPage {
    
    NSTextContainer *container = _layoutManager.textContainers.firstObject;
    
    DYMBookPageVC *vc = [_pagesCache dequeuePageForContainer:container contentSize:_contentSize];
    
    return vc;
}

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index {
    
    if (index >= 0 && index < _layoutManager.textContainers.count) {
        
        NSTextContainer *container = _layoutManager.textContainers[index];
        DYMBookPageVC *vc = [_pagesCache dequeuePageForContainer:container contentSize:_contentSize];
        
        return vc;
    }
    
    return nil;
}

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC {
    return [_layoutManager.textContainers indexOfObject:pageVC.textContainer];
}


@end
