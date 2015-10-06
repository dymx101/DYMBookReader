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

@property (nonatomic, strong, readonly) NSTextContainer     *textContainer;
@property (nonatomic, assign, readonly) CGSize              contentSize;

@end

@implementation DYMBookPageVC

-(void)setTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize {
    _textContainer = textContainer;
    _contentSize = contentSize;
    
    CGRect rect = CGRectMake(([UIScreen mainScreen].bounds.size.width - _contentSize.width) / 2
                             , 20
                             , _contentSize.width, _contentSize.height);
    
    _textView = [[DYMBookTextView alloc] initWithFrame:rect textContainer:_textContainer];
    _textView.editable = NO;
    _textView.scrollEnabled = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_textView];
}



@end
