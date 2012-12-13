//
//  SDSelectableCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDSelectableCell.h"

@implementation SDSelectableCell

@synthesize  parentNestedTableController, cellState, cellIndexPath;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        cellState = Unchecked;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (LLCellState) toggleCheck
{
    if (cellState == Checked)
    {
        [self uncheck];
    }
    else
    {
        [self check];
    }
    return cellState;
}

- (void) check
{
    cellState = Checked;
}

- (void) uncheck
{
    cellState = Unchecked;
}



@end
