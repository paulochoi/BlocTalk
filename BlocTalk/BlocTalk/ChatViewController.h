//
//  ChatViewController.h
//  BlocTalk
//
//  Created by Paulo Choi on 10/1/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"
#import "Conversations.h"


@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) DemoModelData *demoData;
@property (strong, nonatomic) Conversations *conversations;
@property (copy, nonatomic) NSString *peerID;
@property (copy, nonatomic) NSString *deviceID;


- (void)closePressed:(UIBarButtonItem *)sender;


@end
