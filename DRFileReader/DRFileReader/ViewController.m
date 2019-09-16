//
//  ViewController.m
//  DRFileReader
//
//  Created by DamonRao on 2019/9/11.
//  Copyright © 2019年 DR. All rights reserved.
//

#import "ViewController.h"
#import "ReaderView/DRFileReaderViewer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];

}

-(void)initUI
{
 
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(40,100,self.view.frame.size.width-80, 30);
    
    [refreshButton setTitle:@"zip解压文件" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton setBackgroundColor:[UIColor lightGrayColor]];
    [refreshButton addTarget:self action:@selector(refreshBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];

    
    UIButton *open1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    open1Btn.frame = CGRectMake(40,200,self.view.frame.size.width-80, 30);
    [open1Btn setTitle:@"打开文件" forState:UIControlStateNormal];
    [open1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [open1Btn setBackgroundColor:[UIColor lightGrayColor]];
    [open1Btn addTarget:self action:@selector(open1BtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:open1Btn];
}

-(void)refreshBtnClcik
{
   NSString *filePath=[[NSBundle mainBundle] pathForResource:@"img" ofType:@"zip"];
    
   NSString *appLib = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;

    BOOL file=[self copyMissingFile:filePath toPath:appLib];
    
    if(file)
    {
        NSString *path= [appLib stringByAppendingPathComponent:@"img.zip"];
        
        [[DRFileReaderViewer sharedFileReader] openFilePath:path complete:^(NSString * _Nonnull error) {
            
        }];
    }
  
}




-(void)open1BtnClick
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"file" ofType:@"png"];
    
    
    [[DRFileReaderViewer sharedFileReader] openFilePath:filePath complete:^(NSString * _Nonnull error) {
        
    }];
}


- (BOOL)copyMissingFile:(NSString*)sourcePath toPath:(NSString*)toPath{
    
    BOOL retVal = YES; // If the file already exists, we'll return success…
    
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
     {
       retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
      }
    return retVal;
}
@end
