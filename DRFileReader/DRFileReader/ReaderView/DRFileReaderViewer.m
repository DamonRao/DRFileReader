//
//  DRFileReaderViewer.m
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import "DRFileReaderViewer.h"
#import <UnrarKit/UnrarKit.h>
#import <ZipArchive/ZipArchive.h>
#import "DRFolderViewer.h"
#import "DRFilePreViewController.h"

@implementation DRFileReaderViewer


+ (instancetype)sharedFileReader
{
    static DRFileReaderViewer *fileReader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileReader = [[DRFileReaderViewer alloc]init];
    });
    return fileReader;
}

-(void)openFilePath:(NSString *)filePath complete:(void(^)(NSString *error))complete
{
    
    if ([[filePath pathExtension] isEqualToString:@"rar"]) {
        
        NSError *archiveError = nil;
        URKArchive *archive = [[URKArchive alloc] initWithPath:filePath error:&archiveError];
        if (!archive) {
            NSLog(@"URKArchive初始化失败");
            complete(archiveError.localizedDescription);
            return;
        }
        
        NSError *error = nil;
        NSString *DictfilePath = [[filePath componentsSeparatedByString:@".rar"] firstObject];
        
        [archive extractFilesTo:DictfilePath overwrite:YES progress:^(URKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
            
        } error:&error];
        
        if (!error) {
            
            [self openFolderWithPath:DictfilePath];
            
             complete(nil);
        }
        
        
        
    }
    else if([[filePath pathExtension] isEqualToString:@"zip"]) {
        
        NSString *DictfilePath = [[filePath componentsSeparatedByString:@".zip"] firstObject];
        BOOL success = [SSZipArchive unzipFileAtPath:filePath
                                       toDestination:DictfilePath];
        
        if (success) {
            
            [self openFolderWithPath:DictfilePath];
            
            complete(nil);
            
        }else
        {
            NSLog(@"SSZipArchive初始化失败");
            complete(@"SSZipArchive初始化失败");
        }
    }else
    {
        [self openFileViewrWith:filePath];
        
        complete(nil);
    }
}

-(void)openFolderWithPath:(NSString *)filePath
{
    DRFolderViewer *readerVC = [[DRFolderViewer alloc] initWithFolderPath:filePath rootFolder:YES];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readerVC];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController *)rootViewController;
        [navController.visibleViewController presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        
        if (rootViewController.presentedViewController) {
            [rootViewController.presentedViewController presentViewController:navigationController animated:YES completion:nil];
        } else {
            [rootViewController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}

-(void)openFileViewrWith:(NSString *)filePath
{
    DRFilePreViewController *previewController = [DRFilePreViewController new];
    previewController.filePath = filePath;
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController *)rootViewController;
        [navController.visibleViewController presentViewController:previewController animated:YES completion:nil];
        
    } else {
        
        if (rootViewController.presentedViewController) {
            [rootViewController.presentedViewController presentViewController:previewController animated:YES completion:nil];
        } else {
            [rootViewController presentViewController:previewController animated:YES completion:nil];
        }
    }
}
@end
