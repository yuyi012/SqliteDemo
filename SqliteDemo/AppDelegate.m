//
//  AppDelegate.m
//  SqliteDemo
//
//  Created by 俞 億 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CompanyStructureController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize datebase;
- (void)dealloc
{
    [_window release];
    [datebase release];
    [super dealloc];
}

+(AppDelegate*)sharedAppDelegate{
    return [[UIApplication sharedApplication]delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Do any additional setup after loading the view.
    NSString *documentPath = [self applicationDocumentsFileDirectory];
    NSString *currentFileName = [NSString stringWithFormat:@"CompanyStructure.rdb"];
    NSString *currentFilePath = [documentPath stringByAppendingPathComponent:currentFileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:currentFilePath]) {
        
    }else {
        //因为用户安装了老的版本，其中sqlite文件和最新版本不一致，从资源目录把最新的sqlite文件拷贝到document里面
        //一定要拷贝到document目录下面，因为resouce目录是只读的
        //会丢失用户在老版本中所有的数据
        //可以运行一段sql脚本，把数据从老的sqlite文件中迁移到新的sqlite
        NSString *resourceFilePath = [[NSBundle mainBundle]pathForResource:@"CompanyStructure"
                                                                    ofType:@"rdb"];
        [[NSFileManager defaultManager]copyItemAtPath:resourceFilePath toPath:currentFilePath error:NULL];
    }
    self.datebase = [[FMDatabase alloc]initWithPath:currentFilePath];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    CompanyStructureController *companyController = [[CompanyStructureController alloc]init];
    self.window.rootViewController = companyController;
    [companyController release];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    return YES;
}


- (NSString *)applicationDocumentsFileDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end
