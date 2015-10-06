//
//  DYMBookProvider.m
//  Pods
//
//  Created by Dong Yiming on 15/10/3.
//
//

#import "DYMBookProvider.h"

@interface DYMBookProvider ()

@end

@implementation DYMBookProvider

+(NSString *)loadBookAtURL:(NSURL *)url {
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:url.absoluteString]) {
//        NSData *data = [NSData dataWithContentsOfFile:url.absoluteString];
//        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
    NSError *error;
    
    NSString *str = [NSString stringWithContentsOfFile:url.absoluteString encoding:NSUTF8StringEncoding error:&error];
    return str;
}



@end
