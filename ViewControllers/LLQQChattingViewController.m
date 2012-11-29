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
    UIToolbar *_toolbar;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillChangeFrame:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];  
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
    _toolbar = [objs objectAtIndex:0];
    _toolbar.frame = CGRectMake(0,
                               frame.size.height,
                               _toolbar.frame.size.width, 
                               _toolbar.frame.size.height);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bubbleView];
    [self.view addSubview:_toolbar];
    [_bubbleView setBackgroundColor:[UIColor clearColor]];
    [_bubbleView setBubbleDataSource:self];
    
    [self testBubbleRecords];
    [_bubbleView reloadData];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSValue *beginFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect beginFrame = [beginFrameValue CGRectValue];
    CGRect endFrame = [endFrameValue CGRectValue];
    beginFrame = [self.view convertRect:beginFrame fromView:nil];
    endFrame = [self.view convertRect:endFrame fromView:nil];
    
    /*
    NSLog(@"begin frame :%f, %f, %f, %f", beginFrame.origin.x, beginFrame.origin.y, beginFrame.size.width, beginFrame.size.height);
    NSLog(@"end frame :%f, %f, %f, %f", endFrame.origin.x, endFrame.origin.y, endFrame.size.width, 
          endFrame.size.height);
    */
    NSNumber *duration = [[notification userInfo] 
                          objectForKey:UIKeyboardAnimationDurationUserInfoKey];    
    
    [UIView animateWithDuration:duration.floatValue animations:^(void){
        
        long X = _toolbar.frame.origin.x;
        long Y = _toolbar.frame.origin.y;
        long W = _toolbar.frame.size.width;
        long H = _toolbar.frame.size.height;
        
        [_toolbar setFrame:CGRectMake(X, endFrame.origin.y - H, W, H)];
        
        X = _bubbleView.frame.origin.x;
        Y = _bubbleView.frame.origin.y;
        W = _bubbleView.frame.size.width;
        H = _bubbleView.frame.size.height;
        
        [_bubbleView setFrame:CGRectMake(X, endFrame.origin.y - H, W, H)];        
    }];
    
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
    
    [self testBubbleRecords];
    [_bubbleView reloadData];
}


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

- (IBAction)sendMsgBtnClicked:(id)sender
{
    for (UIView *subView in [_toolbar subviews]) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [(UITextField *)subView resignFirstResponder];
        }
    }
    
    /* send msg ..... */
    /** add code here **/
}

@end
