//
//  DYMBookPageVC.m
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import "DYMBookPageVC.h"
#import <Masonry/Masonry.h>

@interface DYMBookPageVC () {
    DYMBookTextView      *_textView;
}

@end

@implementation DYMBookPageVC

-(void)setTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize pageEdgeInset:(UIEdgeInsets)pageEdgeInset {
    
//    NSLog(@"------begin init Text View...");
    
    _textContainer = textContainer;
    _contentSize = contentSize;
    _pageEdgeInset = pageEdgeInset;
    
    CGRect rect = CGRectMake(_pageEdgeInset.left
                             , _pageEdgeInset.top
                             , _contentSize.width, _contentSize.height);
    
    _textView = [[DYMBookTextView alloc] initWithFrame:rect textContainer:_textContainer];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
    
//    NSLog(@"------end init Text View...");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.view addSubview:_textView];
}



@end
