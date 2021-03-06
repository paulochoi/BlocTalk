//
//  Conversations.h
//  BlocTalk
//
//  Created by Paulo Choi on 9/23/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Conversations : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) UIImage *avatar;

@end
