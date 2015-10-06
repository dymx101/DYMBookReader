//
//  DYMBookPageDatasource.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>

@interface DYMBookPageDatasource : NSObject

@property (nonatomic, copy, readonly) NSString    *content;

@property (nonatomic, assign, readonly) CGSize    contentSize;

-(void)setContent:(NSString *)content withContentSize:(CGSize)contentSize;

-(NSTextContainer *)navigateToTheBeginning;

-(NSTextContainer *)navigate:(BOOL)forward;

@end
