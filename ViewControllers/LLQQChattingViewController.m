//
//  LLQQChattingViewController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-8.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQChattingViewController.h"
#import "LLNotificationCenter.h"
#import "UIBubbleTableView.h"

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
        [LLNotificationCenter add:self
                         selector:@selector(newMsgNotificationHandler:)
                 notificationType:kNotificationTypeNewMessage];
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
    CGRect frame = self.view.frame;
    frame.size.height -= 44;
    _bubbleView = [[UIBubbleTableView alloc] initWithFrame:frame];
    
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"LLChattingToolbar" owner:self options:nil];
    UIToolbar *toolbar = [objs objectAtIndex:0];
    toolbar.frame = CGRectMake(0,
                               frame.size.height,
                               toolbar.frame.size.width, 
                               toolbar.frame.size.height);
    
//    toolbar.frame.origin = CGPointMake(0, frame.size.height);
    
    [self.view addSubview:_bubbleView];
    [self.view addSubview:toolbar];
    [_bubbleView setBubbleDataSource:self];
    
}

- (void)newMsgNotificationHandler:(NSNotification *)nofi
{
    LLQQMsg *msg = [[nofi userInfo] objectForKey:kNotificationInfoKeyForValue]; 
    
    switch (msg.type) {
        case kQQMsgTypeUser:
        {
            
        }
            break;
        case kQQMsgTypeGroup:
        {
            
        }
            break;
        case kQQMsgTypeDiscus:
        {
            
        }
            break;
        default:
            break;
    }    
    NSString *msgString = [msg.content getString];
    NSBubbleData *chatMsg = [[NSBubbleData alloc] initWithText:msgString
                                                          date:[NSDate dateWithTimeIntervalSince1970:[msg time]]
                                                          type:BubbleTypeSomeoneElse];
    [_bubbles addObject:chatMsg];
    [chatMsg release];
    [_bubbleView reloadData];
}

/*
 - (void)testBubbleRecords
 {
 NSBubbleData *chatRecord1 = [[NSBubbleData alloc] initWithText:@"hello girl"
 date:[NSDate dateWithTimeIntervalSinceNow:-300]
 type:BubbleTypeSomeoneElse];
 
 NSBubbleData *chatRecord2 = [[NSBubbleData alloc] initWithText:@"hi"
 date:[NSDate dateWithTimeIntervalSinceNow:-150]
 type:BubbleTypeMine];
 
 NSBubbleData *chatRecord3 = [[NSBubbleData alloc] initWithText:@"颠"
 date:[NSDate dateWithTimeIntervalSinceNow:1]
 type:BubbleTypeMine];
 
 [_bubbles addObjectsFromArray:[NSArray arrayWithObjects:chatRecord1, chatRecord2, chatRecord3, nil]]; 
 _bubbleView.typingBubble = NSBubbleTypingTypeMe;
 [_bubbleView reloadData];
 }
 */

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
