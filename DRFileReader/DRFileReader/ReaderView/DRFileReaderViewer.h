//
//  DRFileReaderViewer.h
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRFileReaderViewer : NSObject

+ (instancetype)sharedFileReader;

-(void)openFilePath:(NSString *)filePath complete:(void(^)(NSString *error))complete;

@end

NS_ASSUME_NONNULL_END
