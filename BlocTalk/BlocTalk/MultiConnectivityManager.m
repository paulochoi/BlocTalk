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


-(void)setupPeerAndSession{
    self.peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}


-(void)setupMCBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-service" session:self.session];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise){        
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-service" discoveryInfo:nil session:self.session
                           ];
        [self.advertiser start];
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}


#pragma MARK - Delegate Methods
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progres
{
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{

}


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}
@end
