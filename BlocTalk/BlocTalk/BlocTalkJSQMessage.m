//
//  BlocTalkJSQMessage.m
//  BlocTalk
//
//  Created by Paulo Choi on 10/15/15.
//  Copyright © 2015 Paulo Choi. All rights reserved.
//

#import "BlocTalkJSQMessage.h"

@implementation BlocTalkJSQMessage

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self){
        _displayName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(displayName))];
        _userID = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userID))];
        
    }
    
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.displayName forKey:NSStringFromSelector(@selector(displayName))];
    [aCoder encodeObject:self.userID forKey:NSStringFromSelector(@selector(userID))];
}

@end
