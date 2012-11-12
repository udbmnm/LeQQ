//
//  SDGroupCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDGroupCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SDNestedTableViewController.h"

@implementation SDGroupCell

@synthesize isExpanded, subTable, subCellsCount;

+ (int) getHeight
{
    return height;
}

+ (int) getSubCellHeight
{
    return subCellHeight;
}

- (void) setsubCellsCount:(int)newsubCellsCount
{
    subCellsCount = newsubCellsCount;
}

#pragma mark - Lifecycle

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        isExpanded = NO;
        subTable = nil;

    }
    return self;
}

- (LLCellState) toggleCheck
{
    LLCellState cellState = [super toggleCheck];
    return cellState;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return subCellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubCell"];
    
    if (cell == nil)
    {
        NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"SDSubCell" owner:self options:nil];
        cell = [items objectAtIndex:0];
    }
    
    cell = [self.parentNestedTableController mainItem:self prepareSubItem:cell forRowAtIndexPath:indexPath];
    [cell setCellIndexPath:indexPath];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return subCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toggleCheck];
    
    SDSubCell *cell = (SDSubCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = (SDSubCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    [self.parentNestedTableController groupCell:self didSelectSubCell:cell withIndexPath:indexPath];

}

@end
