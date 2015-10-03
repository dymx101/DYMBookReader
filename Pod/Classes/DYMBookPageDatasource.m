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
}

@end

@implementation DYMBookPageDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit {
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
}


@end
