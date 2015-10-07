//
//  DYMBookPageDatasource.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>
#import "DYMBookPageVC.h"

@interface DYMBookPageDatasource : NSObject

@property (nonatomic, copy) NSString    *bookName;

@property (nonatomic, copy) NSString    *chapterTitle;

@property (nonatomic, copy) NSString    *content;

@property (nonatomic, assign) CGSize    contentSize;

@property (nonatomic, strong) UIFont    *font;

@property (nonatomic, strong) UIColor   *textColor;

@property (nonatomic, strong) UIColor   *backgroundColor;

@property (nonatomic, assign) UIEdgeInsets  pageEdgeInset;

-(void)refresh:(dispatch_block_t)block;

-(DYMBookPageVC *)firstPage;

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index;

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC;

@end
