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

-(void)setTextContainer:(NSTextContainer *)textContainer contentSize:(CGSize )contentSize;

@end
