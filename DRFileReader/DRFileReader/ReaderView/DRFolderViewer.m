//
//  DRFolderViewer.m
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import "DRFolderViewer.h"
#import "DRFileReaderViewer.h"
@interface DRFolderViewer ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_folderViewerTable;
    NSMutableArray *_dataSrc;
}

@property (nonatomic, assign) BOOL rootFolder;

@end

@implementation DRFolderViewer


- (instancetype)initWithFolderPath:(NSString *)folderPath rootFolder:(BOOL)rootFolder
{
    self = [super init];
    if (self) {
        _folderPath = folderPath;
        _rootFolder = rootFolder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSrc = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initUserInterface];
    
    [self loadDataSource];
}

- (void)initUserInterface
{
    self.title = [_folderPath lastPathComponent];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    UIView *backItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    backItemView.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backItemView.bounds;
    backButton.titleLabel.font= [UIFont systemFontOfSize:17.f];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backItemView addSubview:backButton];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backItemView];
    
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    if (_rootFolder)
    {
        [backButton setTitle:@"关闭" forState:UIControlStateNormal];
        [backButton setImage:nil forState:UIControlStateNormal];
    }else
    {
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    }
    
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    
    _folderViewerTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    _folderViewerTable.showsVerticalScrollIndicator = NO;
    _folderViewerTable.delegate = self;
    _folderViewerTable.dataSource = self;
    _folderViewerTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    _folderViewerTable.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
    _folderViewerTable.estimatedRowHeight=0;
    _folderViewerTable.estimatedSectionFooterHeight=0;
    _folderViewerTable.estimatedSectionHeaderHeight=0;
    _folderViewerTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_folderViewerTable];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataSource
{
    [_dataSrc removeAllObjects];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_folderPath error:nil];
    
    for (NSString *item in contents) {
        
        if (![item isEqualToString:@"__MACOSX"]) {
            
            NSString *itemPath = [_folderPath stringByAppendingPathComponent:item];
            BOOL isDirectory = NO;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:itemPath isDirectory:&isDirectory]) {
                
                NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:itemPath error:nil];
                
                NSMutableDictionary *itemInfo = [NSMutableDictionary dictionaryWithCapacity:0];
                [itemInfo setObject:item forKey:@"itemName"];
                [itemInfo setObject:itemPath forKey:@"itemPath"];
                NSString *lastModifyTime = [NSString stringWithFormat:@"%.f", [attributes[NSFileModificationDate] timeIntervalSince1970] * 1000];
                [itemInfo setObject:lastModifyTime forKey:@"lastModifyTime"];
                
                if (isDirectory) {
                    [itemInfo setObject:@"Folder" forKey:@"itemType"];
                } else {
                    [itemInfo setObject:@"File" forKey:@"itemType"];
                    [itemInfo setObject:attributes[NSFileSize] forKey:@"itemSize"];
                }
                
                [_dataSrc addObject:itemInfo];
                
            }
            
        }
        
    }
    
    [_folderViewerTable reloadData];
}

- (void)closeButtonClicked
{
    if (_rootFolder) {
        
        if ([_folderPath rangeOfString:NSTemporaryDirectory()].location != NSNotFound) {
            [[NSFileManager defaultManager] removeItemAtPath:_folderPath error:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:name];
}

#pragma mark UITableView Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSrc count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SecpolicyInfoCell";
    
    DRFolderViewerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[DRFolderViewerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell updatesCellWithFileAttributes:[_dataSrc objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *fileDict = [_dataSrc objectAtIndex:indexPath.row];
    
    if ([fileDict[@"itemType"] isEqualToString:@"Folder"]) {
        
        DRFolderViewer *view = [[DRFolderViewer alloc] initWithFolderPath:fileDict[@"itemPath"] rootFolder:NO];
        
        [self.navigationController pushViewController:view animated:YES];
        
        
    } else {
        
        [[DRFileReaderViewer sharedFileReader] openFilePath:fileDict[@"itemPath"] complete:^(NSString * _Nonnull error) {
            
        }];
        
    }
}
@end

@interface DRFolderViewerCell () {
    // 头像
    UIImageView *iconImageView;
    
    // 文件名
    UILabel *fileNameLabel;
    
    // 内容摘要
    UILabel *summaryLabel;
}

@property (nonatomic, assign) BOOL flag;

@end

@implementation DRFolderViewerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        
        fileNameLabel = [[UILabel alloc] init];
        fileNameLabel.font = [UIFont systemFontOfSize:14.0f];
        fileNameLabel.backgroundColor = [UIColor clearColor];
        fileNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:fileNameLabel];
        
        summaryLabel = [[UILabel alloc] init];
        summaryLabel.font = [UIFont systemFontOfSize:12.0f];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:summaryLabel];
        
    }
    return self;
}

- (void)updatesCellWithFileAttributes:(NSDictionary *)fileAttributes
{
    CGFloat cellHeight = 50.f;
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    iconImageView.frame = CGRectMake(20, (cellHeight - 30) / 2, 30, 30);
    
    fileNameLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, (cellHeight - 40) / 2, cellWidth - 85, 20);
    
    summaryLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, CGRectGetMaxY(fileNameLabel.frame), cellWidth - 85, 20);
    
    NSString *fileName = [fileAttributes objectForKey:@"itemName"];
    
//    NSString *extension = [[fileName componentsSeparatedByString:@"."] lastObject];

    if([fileAttributes[@"itemType"] isEqualToString:@"File"])
    {
//        if ([extension isEqualToString:@"zip"]
//            || [extension isEqualToString:@"rar"]) {
//            iconImageView.image = [UIImage imageNamed:@"file_rar"];
//        } else {
//            iconImageView.image = [UIImage imageNamed:@"file_icon"];
//        }
         iconImageView.image = [UIImage imageNamed:@"baseFile"];
    }else
    {
        iconImageView.image = [UIImage imageNamed:@"baseFolder"];
    }
    
    
    
    fileNameLabel.text = fileName;
    
    if ([fileAttributes[@"itemType"] isEqualToString:@"File"]) {
        if ([fileAttributes[@"itemSize"] floatValue] >= 1024 *1024 ) {
            summaryLabel.text = [NSString stringWithFormat:@"%.1fM", [[fileAttributes objectForKey:@"itemSize"] floatValue]/1024/1024];
        } else {
            summaryLabel.text = [NSString stringWithFormat:@"%.1fK", [[fileAttributes objectForKey:@"itemSize"] floatValue]/1024];
        }
    }
}

-(UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:name];
}


@end

