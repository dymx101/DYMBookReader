//
//  DYMBookProvider.h
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import <Foundation/Foundation.h>

@interface DYMBookProvider : NSObject

+(NSString *)bookWithTxtFilePath:(NSString *)filePath;

+(NSDictionary *)bookWithPlistFilePath:(NSString *)filePath;

@end
