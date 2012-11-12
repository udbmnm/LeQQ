//
//  SDGroupCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSubCell.h"

@class SDGroupCell;
@protocol LLGroupCellDelegate <NSObject>
- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDSelectableCell *)subCell withIndexPath: (NSIndexPath *)indexPath;
@end

static const int height = 40;
static const int subCellHeight = 50;

@interface SDGroupCell : SDSelectableCell <UITableViewDelegate, UITableViewDataSource>
{
}

@property (nonatomic) int subCellsCount;
@property (assign) BOOL isExpanded;
@property (assign) IBOutlet UITableView *subTable;

+ (int) getHeight;
+ (int) getSubCellHeight;

@end
