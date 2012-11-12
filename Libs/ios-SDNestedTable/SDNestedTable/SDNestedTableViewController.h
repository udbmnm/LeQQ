//
//  SDNestedTableViewController.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSelectableCell.h"
#import "SDGroupCell.h"
#import "SDSubCell.h"

@protocol SDNestedTableDelegate<NSObject>
@required
/* event callback */
- (void) mainTable:(UITableView *)mainTable item:(SDGroupCell *)item didExpanded:(BOOL)isExpanded;
- (void) mainItem:(SDGroupCell *)item subItemDidClicked:(SDSelectableCell *)subItem;

/* data source */
- (NSInteger) mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section;
- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath;

@optional
- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath;
- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SDNestedTableViewController : UITableViewController<SDNestedTableDelegate, LLGroupCellDelegate>
{
	NSMutableDictionary *mainCellExpandedDic;
}

@property (strong) NSMutableDictionary *subItemsCountDic;

@end
