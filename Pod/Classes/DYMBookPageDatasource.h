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

@property (nonatomic, copy, readonly) NSString    *content;

@property (nonatomic, assign, readonly) CGSize    contentSize;

-(void)setContent:(NSString *)content withContentSize:(CGSize)contentSize;

-(DYMBookPageVC *)firstPage;

-(DYMBookPageVC *)pageAtIndex:(NSInteger)index;

-(NSInteger)indexOfPageVC:(DYMBookPageVC *)pageVC;

@end
