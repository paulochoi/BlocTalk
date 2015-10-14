//
//  ConversationsViewController.m
//  BlocTalk
//
//  Created by Paulo Choi on 9/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "ConversationsViewController.h"
#import "AvailableUsersTableViewCell.h"
#import "ChatViewController.h"
#import "MBProgressHUD.h"

@interface ConversationsViewController () <MCNearbyServiceBrowserDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeWindow;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;
@property (strong, nonatomic) MultiConnectivityManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (assign, nonatomic) NSInteger clickedRow;


@end

@implementation ConversationsViewController

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];;
}


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
    
    [[MultiConnectivityManager sharedInstance] setupPeerAndSession];
    [[MultiConnectivityManager sharedInstance] advertiseSelf:TRUE];
    [[MultiConnectivityManager sharedInstance] setupMCBrowser];
    
    [MultiConnectivityManager sharedInstance].browser.delegate = self;
    [[MultiConnectivityManager sharedInstance].browser startBrowsingForPeers];

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
        MCPeerID *userPeerID = notification.userInfo[@"peerID"];
        NSString *userDeviceFileName = [NSString stringWithFormat:@"%@",userPeerID];
        Users *user = self.userList[self.clickedRow];
        
        NSDictionary *dict = @{@"userDeviceID": userPeerID,
                               @"userID": user.userID
                               };
        
        
        NSLog(@"%@",state);
        
        if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateConnected]] ) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            [self performSegueWithIdentifier:@"chatNow" sender:dict];
            
        } else if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateConnecting]]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
        } else if ([state isEqualToNumber:[NSNumber numberWithInt:MCSessionStateNotConnected]] ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        

    });
}

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}


#pragma mark - browser delegate methods

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    
    Users *user = [Users new];
    user.name = peerID.displayName;
    user.peerID = peerID;
    user.userID = info[@"deviceID"];
    
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
    
    self.clickedRow = indexPath.row;
    
    [[MultiConnectivityManager sharedInstance].browser invitePeer: item.peerID toSession:[MultiConnectivityManager sharedInstance].session withContext:nil timeout:20];
    
    //[self.manager.browser invitePeer: item.peerID toSession:self.manager.session withContext:nil timeout:5];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"chatNow"]){
        ChatViewController *chat = segue.destinationViewController;
        
        chat.peerID = sender[@"userPeerID"];
        chat.deviceID = sender[@"userID"];
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
