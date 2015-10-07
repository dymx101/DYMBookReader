//
//  DYMBookPageDatasource.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>
#import "DYMBookPageVC.h"
#import "DYMBookPageStyle.h"

@interface DYMBookChapter : NSObject

@property (nonatomic, copy) NSString    *bookName;

@property (nonatomic, copy) NSString    *chapterTitle;

@property (nonatomic, copy) NSString    *content;

@property (nonatomic, assign) CGSize    contentSize;

@property (nonatomic, assign) NSUInteger   currentPageIndex;

@property (nonatomic, strong) DYMBookPageStyle    *pageStyle;


-(void)refresh:(dispatch_block_t)block;

-(DYMBookPageVC *)firstPage;

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index;

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC;

-(void)didShowPageVC:(DYMBookPageVC *)pageVC;

@end
