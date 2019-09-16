//
//  DRFolderViewer.h
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRFolderViewer : UIViewController

@property (nonatomic, copy, readonly) NSString *folderPath;

- (instancetype)initWithFolderPath:(NSString *)folderPath rootFolder:(BOOL)rootFolder;

@end


@interface DRFolderViewerCell : UITableViewCell

- (void)updatesCellWithFileAttributes:(nonnull NSDictionary *)fileAttributes;

@end

NS_ASSUME_NONNULL_END
