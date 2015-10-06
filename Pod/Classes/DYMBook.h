//
//  DYMBook.h
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import <Foundation/Foundation.h>

@interface DYMBook : NSObject

-(instancetype)initWithPlistFileName:(NSString *)plistFileName;

-(void)load:(dispatch_block_t)completionBlock;

-(NSArray *)chapters;
-(NSString *)chapterContentAtIndex:(NSInteger)index;
-(NSString *)chapterTitleAtIndex:(NSInteger)index;
-(id)chapterAtIndex:(NSUInteger)index;

@end
