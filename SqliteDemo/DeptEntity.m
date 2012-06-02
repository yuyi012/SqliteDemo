//
//  DeptEntity.m
//  SqliteDemo
//
//  Created by 俞 億 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeptEntity.h"

@implementation DeptEntity
@synthesize deptName;
@synthesize personArray;
- (void)dealloc
{
    [deptName release];
    [personArray release];
    [super dealloc];
}
@end
