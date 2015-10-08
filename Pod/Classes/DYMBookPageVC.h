//
//  DYMBookPageVC.h
//  Pods
//
//  Created by Dong Yiming on 15/10/6.
//
//

#import <UIKit/UIKit.h>
#import "DYMBookTextView.h"

@interface DYMBookPageVC : UIViewController

@property (nonatomic, strong, readonly) NSTextContainer     *textContainer;
@property (nonatomic, assign, readonly) CGSize              contentSize;

@property (nonatomic, assign, readonly) NSUInteger          currentIndex;

@property (nonatomic, assign, readonly) UIEdgeInsets        pageEdgeInset;

@property (nonatomic, weak) id chapter;

-(void)setTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize pageEdgeInset:(UIEdgeInsets)pageEdgeInset;

-(void)setBookName:(NSString *)bookName
       chapterTitle:(NSString *)chapterTitle
      currentIndex:(NSUInteger)currentIndex
   totoalPageCount:(NSUInteger)totoalPageCount
              font:(UIFont *)font
         textColor:(UIColor *)textColor;

@end
