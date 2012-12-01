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
@synthesize friendUin;

- (id)initWitFriendUin:(long)uin
{
    self = [super init];
    if (self) {
        _bubbleView = nil;
        _bubbles = [[NSMutableArray alloc] init];
        self.friendUin = uin;
        
        [LLNotificationCenter add:self
                         selector:@selector(newMsgNotificationHandler:)
                 notificationType:kNotificationTypeUnreadMessageFromFriend];
        
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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                             action:@selector(tagGestureCallback:)];
    tapRecognizer.numberOfTapsRequired = 1;    
    tapRecognizer.numberOfTouchesRequired = 1;
    [_bubbleView addGestureRecognizer:[tapRecognizer autorelease]];  
    [_bubbleView setBackgroundColor:[UIColor clearColor]];
    [_bubbleView setBubbleDataSource:self];
    
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"LLChattingToolbar" owner:self options:nil];
    _toolbar = [objs objectAtIndex:0];
    _toolbar.frame = CGRectMake(0,
                               frame.size.height,
                               _toolbar.frame.size.width, 
                               _toolbar.frame.size.height);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bubbleView];
    [self.view addSubview:_toolbar];

    [self updateWithNewMsg];
    
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

#pragma mark -get unread msgs and update the user interface
- (void)updateWithNewMsg
{
    NSArray *msgs = [[LLQQMsgManager getShareManager] getUnreadMsgsFromFriend:self.friendUin];
    if (msgs == nil) return;
    
    for (LLQQMsg *msg in msgs) {
        NSString *msgString = [msg.content getString];
        NSBubbleData *chatMsg = [[NSBubbleData alloc] initWithText:msgString
                                                              date:[NSDate dateWithTimeIntervalSince1970:[msg time]]
                                                              type:BubbleTypeSomeoneElse];
        [_bubbles addObject:chatMsg];
        [chatMsg release];
    }
    [_bubbleView reloadData]; 
}

#pragma mark -callback of polling Msg noti
- (void)newMsgNotificationHandler:(NSNotification *)nofi
{
    LLQQMsg *msg = [[nofi userInfo] objectForKey:kNotificationInfoKeyForValue]; 
    if (msg.fromUin != self.friendUin) {
        DEBUG_LOG_WITH_FORMAT(@"Not this friend %ld's msg(from %ld)", self.friendUin, msg.fromUin);
        return;
    }
    
    /* 
     * new msg from this friend come in
     * get them.
     */
    [self updateWithNewMsg];
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

#pragma mark -"send" button callback
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

#pragma mark -keyboard frame changed noti callback
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

#pragma mark -single tap recognizer
- (void)tagGestureCallback:(id)sender
{
    for (UIView *subView in [_toolbar subviews]) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [(UITextField *)subView resignFirstResponder];
        }
    }   
}
@end
