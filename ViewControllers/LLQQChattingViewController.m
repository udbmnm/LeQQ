//
//  LLQQChattingViewController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-8.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQChattingViewController.h"

@interface LLQQChattingViewController ()
{
    UIBubbleTableView *_bubbleView;
    NSMutableArray *_bubbles;
}
@end

@implementation LLQQChattingViewController

- (id)init
{
    self = [super init];
    if (self) {
        _bubbleView = nil;
        _bubbles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_bubbleView release];
    [_bubbles release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bubbleView = [[UIBubbleTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_bubbleView];
    [_bubbleView setBubbleDataSource:self];
    
    [self testBubbleRecords];
}

- (void)testBubbleRecords
{
    NSBubbleData *chatRecord1 = [[NSBubbleData alloc] initWithText:@"hello girl" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:NSBubbleTypingTypeSomebody];
    NSBubbleData *chatRecord2 = [[NSBubbleData alloc] initWithText:@"hi" date:[NSDate dateWithTimeIntervalSinceNow:-150] type:NSBubbleTypingTypeMe];
    NSBubbleData *chatRecord3 = [[NSBubbleData alloc] initWithText:@"颠" date:[NSDate dateWithTimeIntervalSinceNow:1] type:NSBubbleTypingTypeSomebody];
    
    [_bubbles addObjectsFromArray:[NSArray arrayWithObjects:chatRecord1, chatRecord2, chatRecord3, nil]];  
    [_bubbleView reloadData];

}

- (void)viewDidUnload
{
    [_bubbleView release];
    _bubbleView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark ----> UIBubbleTableViewDataSource methods
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbles count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbles objectAtIndex:row];
}

@end
