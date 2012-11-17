//
//  SDNestedTableViewController.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDNestedTableViewController.h"

@interface SDNestedTableViewController ()

@end

@implementation SDNestedTableViewController

@synthesize  subItemsCountDic;

- (id) init
{
    if (self = [self initWithNibName:@"SDNestedTableView" bundle:nil])
    {
        
    }
    return self;
}

#pragma mark - To be implemented in sublclasses(for data source)

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"\n Oops! You didn't specify the amount of Items in the Main tableview \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
    return 0;
}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"\n Oops! You didn't specify the amount of Sub Items for this Main Item \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
    return 0; 
}

/* config the GroupCell in this method before showing */
- (SDGroupCell *)mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == 0)
    {
        NSLog(@"\n Oops! Item cells in the Main tableview are not configured \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
    }
    return item;
}

/*config the SubCell in this method before showing */
- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row == 0)
    {
        NSLog(@"\n Oops! Sub Items for this Item are not configured \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
    }
    return subItem;
}

- (void) mainTable:(UITableView *)mainTable item:(SDGroupCell *)item didExpanded:(BOOL)isExpanded
{
    NSLog(@"\n Oops! You didn't specify a behavior for this Item \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
}

- (void) mainItem:(SDGroupCell *)item subItemDidClicked:(SDSelectableCell *)subItem
{
    NSLog(@"\n Oops! You didn't specify a behavior for this Sub Item \n Please implement \"%@\" in your SDNestedTables subclass.", NSStringFromSelector(_cmd));
}

#pragma mark - Class lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* key: indexPath, value: NSNumber of count of subcells of main cell at indexPath */
    subItemsCountDic = [[NSMutableDictionary alloc] init];
    /* key: indexPath, value: bool value (is the cell expanded now) */
	mainCellExpandedDic = [[NSMutableDictionary alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor grayColor];
}

#pragma mark - TableView delegation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self mainTable:tableView numberOfItemsInSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    if (cell == nil)
    {
        NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"SDGroupCell" owner:self options:nil];
        cell = [items objectAtIndex:0];
    }
    
    [cell setParentNestedTableController: self];
    [cell setCellIndexPath:indexPath];
    
    NSNumber *subItemsNum = [NSNumber numberWithInt:[self mainTable:tableView numberOfSubItemsforItem:cell atIndexPath:indexPath]];
    [subItemsCountDic setObject:subItemsNum forKey:indexPath];
    [cell setSubCellsCount:[subItemsNum intValue]];
    
    BOOL isExpanded = NO;
    if ([mainCellExpandedDic objectForKey:indexPath] == nil) {
        isExpanded = [[mainCellExpandedDic objectForKey:indexPath] boolValue];
    } else {
        isExpanded = NO;
    }
    cell.isExpanded = isExpanded;    
    [cell.subTable reloadData];
    
    /* call the delegate to init the main item*/
    cell = [self mainTable:tableView prepareItem:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int amt = [[subItemsCountDic objectForKey:indexPath] intValue];
    BOOL isExpanded = [[mainCellExpandedDic objectForKey:indexPath] boolValue];
    
    if(isExpanded)
    {
        /* when expanded the subcell's height includes the height of all sub cells */
        return [SDGroupCell getHeight] + [SDGroupCell getSubCellHeight]*amt + 0;
    }
    return [SDGroupCell getHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isExpanded = [[mainCellExpandedDic objectForKey:indexPath] boolValue];
	[mainCellExpandedDic setObject:[NSNumber numberWithBool:!isExpanded] forKey:indexPath];
    
    //[self.tableView beginUpdates];
    //[self.tableView endUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self mainTable:self.tableView 
               item:(SDGroupCell *)[self.tableView cellForRowAtIndexPath:indexPath] 
        didExpanded:!isExpanded];
}

#pragma mark - LLGroupCellDelegate
/* called from GroupCell, call the delegate method to notify */
- (void) groupCell:(SDGroupCell *)cell 
  didSelectSubCell:(SDSelectableCell *)subCell
     withIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *groupCellIndexPath = [self.tableView indexPathForCell:cell];
    
    if(groupCellIndexPath == nil)
    {
        return;
    }
    
    [self mainItem:cell subItemDidClicked:subCell];
}

@end
