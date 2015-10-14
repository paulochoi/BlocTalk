//
//  CurrentConversationsViewController.m
//  BlocTalk
//
//  Created by Paulo Choi on 10/8/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "CurrentConversationsViewController.h"
#import "CurrentConversationsTableViewCell.h"
#import "Conversations.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <JSQMessagesViewController/JSQMessages.h>




@interface CurrentConversationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *conversationsList;
@property (weak, nonatomic) IBOutlet UIView *noMessage;

@end

@implementation CurrentConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSError *error;
    
    self.conversationsList = [NSMutableArray new];
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if ([directoryContents count] == 1){
        self.tableView.hidden = TRUE;
        
    } else {
        self.noMessage.hidden = TRUE;
        
        for (NSString *fileName in directoryContents){
            NSString *path = [self pathForFilename:fileName];
            NSLog(@"%@",path);
            
            NSArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
            
            JSQMessage *lastMessage = [unarchivedArray lastObject];
            
            if (unarchivedArray != nil) {
                [self.conversationsList addObject:lastMessage];
            }
        }
        
        NSLog(@"%@", self.conversationsList);

    }
    
}

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CurrentConversationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    if (cell){
        // Configure the cell...
        
        JSQMessage *message = self.conversationsList[indexPath.row];
        
        cell.textPreview.text = message.text;
        cell.userName.text = message.senderDisplayName;
        
        //cell.userName.text = user.name;
        //cell.textPreview.text = @"Lorem ipsum dolor sit amet, alia essent facilisis cu vel, iudico adolescens et mea. No cum vero justo signiferumque. Ut vide assueverit est, vel idque virtute man";
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [self.userList count];
    return [self.conversationsList count];
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}



@end
