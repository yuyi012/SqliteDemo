//
//  CompanyStructureController.m
//  SqliteDemo
//
//  Created by 俞 億 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CompanyStructureController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "DeptEntity.h"
#import "PersonEntity.h"
#import "AppDelegate.h"

@interface CompanyStructureController ()

@end

@implementation CompanyStructureController

-(void)loadView{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = container;
    [container release];
    
    DataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 420)];
    DataTable.delegate = self;
    DataTable.dataSource = self;
    [self.view addSubview:DataTable];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:searchBar];
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
}

- (void)dealloc
{
    [deptArray release];
    [DataTable release];
    [searchBar release];
    [searchDisplayController release];
    [searchResultsArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	deptArray = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.datebase open];
    FMResultSet *results = [appDelegate.datebase executeQuery:@"select p.personId personId,p.personName personName,d.deptName deptName from person p,dept d where p.deptid=d.deptid"];
    while ([results next]) {
        NSString *deptName = [results stringForColumn:@"deptName"];
        
        PersonEntity *personEntity = [[PersonEntity alloc]init];
        personEntity.personName = [results stringForColumn:@"personName"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deptName=%@",deptName];
        NSArray *filteredDeptArray = [deptArray filteredArrayUsingPredicate:predicate];
        if (filteredDeptArray.count>0) {
            DeptEntity *deptEntity = [filteredDeptArray lastObject];
            [deptEntity.personArray addObject:personEntity];
            //NSLog(@"dept exist:%@,person:%@",deptName,personEntity.personName);
        }else {
            DeptEntity *deptEntity = [[DeptEntity alloc]init];
            deptEntity.deptName = deptName;
            deptEntity.personArray = [[NSMutableArray alloc]init];
            [deptEntity.personArray addObject:personEntity];
            [deptArray addObject:deptEntity];
            //NSLog(@"dept create:%@,person:%@",deptName,personEntity.personName);
        }
        [personEntity release];
    }
    [appDelegate.datebase close];
    
//    [db executeUpdate:@"INSERT INTO User (Name,Age) VALUES (?,?)",@"法师",[NSNumber numberWithInt:20]]    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.datebase open];
    NSString *sqlStr = [NSString stringWithFormat:@"select p.personId personId,p.personName personName,d.deptName deptName from person p,dept d where p.deptid=d.deptid and (p.personName like '%%%@%%' or d.deptName like '%%%@%%')",searchString,searchString];
    FMResultSet *results = [appDelegate.datebase executeQuery:sqlStr];
    [searchResultsArray release];
    searchResultsArray = [[NSMutableArray alloc]init];
    while ([results next]) {
        NSString *deptName = [results stringForColumn:@"deptName"];
        PersonEntity *personEntity = [[PersonEntity alloc]init];
        personEntity.personName = [results stringForColumn:@"personName"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deptName=%@",deptName];
        NSArray *filteredDeptArray = [searchResultsArray filteredArrayUsingPredicate:predicate];
        if (filteredDeptArray.count>0) {
            DeptEntity *deptEntity = [filteredDeptArray lastObject];
            [deptEntity.personArray addObject:personEntity];
            NSLog(@"dept exist:%@,person:%@",deptName,personEntity.personName);
        }else {
            DeptEntity *deptEntity = [[DeptEntity alloc]init];
            deptEntity.deptName = deptName;
            deptEntity.personArray = [[NSMutableArray alloc]init];
            [deptEntity.personArray addObject:personEntity];
            [searchResultsArray addObject:deptEntity];
            NSLog(@"dept create:%@,person:%@",deptName,personEntity.personName);
        }
        [personEntity release];
    }
    [appDelegate.datebase close];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberOfSections = 0;
    if (tableView==DataTable) {
        numberOfSections = deptArray.count;
    }else {
        numberOfSections = searchResultsArray.count;
    }
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DeptEntity *deptEntity = nil;
    if (tableView==DataTable) {
        deptEntity = [deptArray objectAtIndex:section];
    }else {
        deptEntity = [searchResultsArray objectAtIndex:section];
    }
    return deptEntity.deptName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DeptEntity *deptEntity = nil;
    if (tableView==DataTable) {
        deptEntity = [deptArray objectAtIndex:section];
    }else {
        deptEntity = [searchResultsArray objectAtIndex:section];
    }
    return deptEntity.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeptEntity *deptEntity = nil;
    if (tableView==DataTable) {
        deptEntity = [deptArray objectAtIndex:indexPath.section];
    }else {
        deptEntity = [searchResultsArray objectAtIndex:indexPath.section];
    }
    PersonEntity *personEntity = [deptEntity.personArray objectAtIndex:indexPath.row];
    UITableViewCell *personCell = [DataTable dequeueReusableCellWithIdentifier:@"personCell"];
    if (personCell==nil) {
        personCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"personCell"]autorelease];
    }
    personCell.textLabel.text = personEntity.personName;
    return personCell;
}
@end
