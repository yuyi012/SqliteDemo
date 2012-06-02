//
//  PersonEntity.m
//  SqliteDemo
//
//  Created by 俞 億 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonEntity.h"

@implementation PersonEntity
@synthesize personName;
- (void)dealloc
{
    [personName release];
    [super dealloc];
}
@end
