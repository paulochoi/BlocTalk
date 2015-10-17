//
//  MultiConnectivityManager.m
//  BlocTalk
//
//  Created by Paulo Choi on 9/23/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "MultiConnectivityManager.h"


@implementation MultiConnectivityManager

-(instancetype)init {
    self = [super init];
    
    if (self){
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    
    return self;
}


+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)setupPeerAndSession{
    self.peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}


-(void)setupMCBrowser {
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:@"chat-service"];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise){
        NSDictionary *dict = @{@"deviceID": [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"],
                               @"deviceDisplayName": [[UIDevice currentDevice] name]};
        
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-service" discoveryInfo:dict session:self.session];
        
        [self.advertiser start];
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (void) saveDataToDiskWithMessageArray: (NSArray *)messages fromUser: (NSString *) userID{
    
    [NSKeyedArchiver archiveRootObject:messages toFile:[self pathForFilename:userID]];
    
    
}

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSLog(@"%@",dataPath);
    return dataPath;
}

- (NSArray *) loadMessagesForPeerID: (NSString *) peerID {
    
    NSArray *array;
    
    @try {
        if ([NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForFilename:peerID]]){
            array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForFilename:peerID]];
        } else {
            array = [NSArray new];
        }
        
    }
    @catch (NSException *exception) {
        array = [NSArray new];
    }
    
    return array;
}

#pragma MARK - Delegate Methods
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progres
{
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
} 


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    
    NSDictionary *dict = @{@"peerID": peerID.displayName, @"state" : [NSNumber numberWithInt:state]};
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    //NSMAPTABLE keys are strong and objects are weak
}

@end
