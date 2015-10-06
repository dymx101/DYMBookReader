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
    UITextView      *_textView;
}

@property (nonatomic, strong) NSTextContainer   *textContainer;
@property (nonatomic, assign) CGSize            contentSize;

@end

@implementation DYMBookPageVC

-(instancetype)initWithTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize {
    self = [super init];
    if (self) {
        _textContainer = textContainer;
        _contentSize = contentSize;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:_textContainer];
    _textView.editable = NO;
    
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(@(_contentSize.height));
        make.width.equalTo(@(_contentSize.width));
    }];
}



@end
