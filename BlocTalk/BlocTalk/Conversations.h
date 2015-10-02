//
//  Conversations.h
//  BlocTalk
//
//  Created by Paulo Choi on 9/23/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSQMessages.h"

@interface Conversations : NSObject

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSDictionary *users;

@end
