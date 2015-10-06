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
    NSInteger           _currentIndex;
}



@end



@implementation DYMBookPageDatasource

-(void)setContent:(NSString *)content withContentSize:(CGSize)contentSize {
    
    _content = content;
    _contentSize = contentSize;
    
    _storage = [[NSTextStorage alloc] initWithString:_content];
    _layoutManager = [[NSLayoutManager alloc] init];
    [_storage addLayoutManager:_layoutManager];
    
    //
    NSRange range = NSMakeRange(0, 0);
    NSUInteger  containerIndex = 0;
    while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:_contentSize];
        [_layoutManager addTextContainer:container];
        
        range = [_layoutManager glyphRangeForTextContainer:container];
        containerIndex++;
    }
    
    _currentIndex = 0;
}

-(NSTextContainer *)navigateToTheBeginning {
    return _layoutManager.textContainers.firstObject;
}

-(NSTextContainer *)navigate:(BOOL)forward {
    forward ? _currentIndex++ : _currentIndex--;
    
    if (_currentIndex >= 0 && _currentIndex < _layoutManager.textContainers.count) {
        return _layoutManager.textContainers[_currentIndex];
    } else if (_currentIndex < 0) {
        _currentIndex = 0;
    } else {
        _currentIndex = _layoutManager.textContainers.count - 1;
    }
    
    return nil;
}


@end
