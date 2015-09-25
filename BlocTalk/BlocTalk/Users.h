//
//  Users.h
//  BlocTalk
//
//  Created by Paulo Choi on 9/23/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MultiConnectivityManager.h"

@interface Users : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIImage *avatar;
@property (nonatomic,strong) MCPeerID *peerID;

@end
