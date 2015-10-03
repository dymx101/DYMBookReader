//
//  DYMBookReaderViewController.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookReaderViewController.h"
#import "DYMBookProvider.h"

@interface DYMBookReaderViewController () {
    NSString *_content;
}

@end

@implementation DYMBookReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _content = [DYMBookProvider loadBookAtURL:_bookURL];
}


@end
