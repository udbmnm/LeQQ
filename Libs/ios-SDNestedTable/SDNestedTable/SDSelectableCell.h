//
//  SDSelectableCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDNestedTableViewController;

#ifndef _LLCellState
#define _LLCellState
typedef enum
{
    Unchecked = 1,
    Checked = 2, 
    
}LLCellState;

#endif

@interface SDSelectableCell : UITableViewCell
{

}
@property (strong) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) SDNestedTableViewController *parentNestedTableController;
@property (nonatomic) LLCellState cellState;           /*当前选中状态*/

- (LLCellState) toggleCheck;
- (void) check;
- (void) uncheck;

@end
