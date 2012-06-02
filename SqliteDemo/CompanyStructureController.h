//
//  CompanyStructureController.h
//  SqliteDemo
//
//  Created by 俞 億 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyStructureController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>{
    UITableView *DataTable;
    NSMutableArray *deptArray;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchResultsArray;
}
@end
