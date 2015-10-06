//
//  DYMAppDelegate.m
//  DYMBookReader
//
//  Created by Daniel Dong on 10/03/2015.
//  Copyright (c) 2015 Daniel Dong. All rights reserved.
//

#import "DYMAppDelegate.h"
#import "DYMBookReaderViewController.h"

@implementation DYMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"txt"];
    
    DYMBookReaderViewController *vc = (DYMBookReaderViewController *)self.window.rootViewController;
    vc.plistFileName = @"花千骨";
    vc.customFontName = @"FlagBlack";
    vc.pageEdgeInset = UIEdgeInsetsMake(20, 20, 10, 10);
    
    return YES;
}

@end
