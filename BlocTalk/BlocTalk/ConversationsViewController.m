//
//  ConversationsViewController.m
//  BlocTalk
//
//  Created by Paulo Choi on 9/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "ConversationsViewController.h"
#import "AvailableUsersTableViewCell.h"

@interface ConversationsViewController () <MCNearbyServiceBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;
@property (strong, nonatomic) MultiConnectivityManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation ConversationsViewController

- (IBAction)startNewConversation:(id)sender {
//    [self.manager setupMCBrowser];
//    self.manager.browser.delegate = self;
//    [self.manager.browser startBrowsingForPeers];
    
    //[self presentViewController:self.manager.browser animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //setting unicode settings icon to left navication button
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:26.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, NSFontAttributeName, nil];
    [self.settingButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    //should this go under the app delegate?
    //self.manager = [[MultiConnectivityManager alloc] init];
    //[self.manager setupPeerAndSession];
    [[MultiConnectivityManager sharedInstance] setupPeerAndSession];
    [[MultiConnectivityManager sharedInstance] advertiseSelf:TRUE];
    //[self.manager advertiseSelf:TRUE];
    
    [[MultiConnectivityManager sharedInstance] setupMCBrowser];
    //[self.manager setupMCBrowser];
    
    [MultiConnectivityManager sharedInstance].browser.delegate = self;
    //self.manager.browser.delegate = self;
    
    [[MultiConnectivityManager sharedInstance].browser startBrowsingForPeers];
    //[self.manager.browser startBrowsingForPeers];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    self.userList = [NSMutableArray new];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{

    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *state = notification.userInfo[@"state"];
        
        NSLog(@"%@",state);
        
        if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateConnected]] ) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Found Peer"
                                                            message:[NSString stringWithFormat:@"%@", notification.userInfo]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK",nil];
            [alert show];
            
            [self performSegueWithIdentifier:@"chatNow" sender:self];
            
        } else if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateConnecting]]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
        } else if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateNotConnected]] ){
            
        }

    });
}



#pragma mark - browser delegate methods

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    
    Users *user = [Users new];
    user.name = peerID.displayName;
    user.peerID = peerID;
    
    [self.userList addObject:user];
    
    [self.tableView reloadData];
    
    //[browser invitePeer:peerID toSession:self.manager.session withContext:nil timeout:5];

}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

#pragma mark - tableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AvailableUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    if (cell){
        // Configure the cell...

        Users *user = self.userList[indexPath.row];
        
        cell.userNameLabel.text = user.name;
        cell.text.text = @"Lorem ipsum dolor sit amet, alia essent facilisis cu vel, iudico adolescens et mea. No cum vero justo signiferumque. Ut vide assueverit est, vel idque virtute man";
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Users *item = self.userList[indexPath.row];
    
    [[MultiConnectivityManager sharedInstance].browser invitePeer: item.peerID toSession:[MultiConnectivityManager sharedInstance].session withContext:nil timeout:5];
    //[self.manager.browser invitePeer: item.peerID toSession:self.manager.session withContext:nil timeout:5];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue isEqual: @"chatNow"]){
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userList count];
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}



@end
