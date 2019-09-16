//
//  DRFilePreViewController.m
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import "DRFilePreViewController.h"
#import <QuickLook/QuickLook.h>

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define IS_IPHONE_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define StatueBarHeight ((IS_IPHONE_XS_MAX || IS_IPHONE_XR || IS_IPhoneX_All) ? (44) : (20))

#define AeraSizeHeight ((IS_IPHONE_XS_MAX || IS_IPHONE_XR || IS_IPhoneX_All) ? (34) : (0))



@interface DRFilePreViewController ()<QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@end

@implementation DRFilePreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    [self initData];
}



- (void)initUI
{
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, StatueBarHeight,SCREEN_WIDTH, 44)];
    navigationView.tag=111112;
    [self.view addSubview:navigationView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10,0, 50, 44);
    backButton.tag=111113;
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,0, SCREEN_WIDTH - 120, 44)];
    titleLabel.tag=111114;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.text = @"阅览";
    [navigationView addSubview:titleLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 50, 44);
    //    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.tag=111115;
    [shareButton setImage:[UIImage imageNamed:@"btn_share_nor"] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareFile:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:shareButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,43.5,SCREEN_WIDTH, 0.5f)];
    lineView.tag=111116;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [navigationView addSubview:lineView];
}

- (void)initData
{
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    if ([QLPreviewController canPreviewItem:(id<QLPreviewItem>)url]) {
        
        QLPreviewController *qlVc = [[QLPreviewController alloc] init];
        qlVc.view.frame = CGRectMake(0, 44 + StatueBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-StatueBarHeight-44-AeraSizeHeight);
        qlVc.delegate = self;
        qlVc.dataSource = self;
        qlVc.navigationController.navigationBar.userInteractionEnabled = YES;
        qlVc.view.userInteractionEnabled = YES;
        [self.view addSubview:qlVc.view];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 9 || [[[UIDevice currentDevice] systemVersion] floatValue] >=11)
        {
            [self addChildViewController:qlVc];
            
        }
        
    }
}

#pragma mark -- Action
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareFile:(UIButton *)sender
{
    NSURL *urlToShare = [NSURL fileURLWithPath:self.filePath];
    NSArray *activityItems = @[urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)]) {
        activityVC.popoverPresentationController.sourceView = sender;
        activityVC.popoverPresentationController.sourceRect = sender.bounds;
    }
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

#pragma mark - QLPreviewController 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:self.filePath];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end

