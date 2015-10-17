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
#import "BlocTalkJSQMessage.h"
#import <SWTableViewCell.h>
#import "MultiConnectivityManager.h"



@interface CurrentConversationsViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
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
    self.navigationItem.title = @"BlocTalk";

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSError *error;
    
    self.conversationsList = [NSMutableArray new];
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if ([directoryContents count] <= 2){
        self.tableView.hidden = TRUE;
        self.noMessage.hidden = FALSE;
        
    } else {
        self.noMessage.hidden = TRUE;
        
        //needs for optimization
        
        for (NSString *fileName in directoryContents){
            NSString *path = [self pathForFilename:fileName];
            NSLog(@"%@",path);
            
            NSArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
            
            BlocTalkJSQMessage *lastMessage = [unarchivedArray lastObject];
            
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
        
        BlocTalkJSQMessage *message = self.conversationsList[indexPath.row];
        
        cell.textPreview.text = message.text;
        cell.userName.text = message.displayName;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
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


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Archive"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    //NSLog(@"%@",cellIndexPath);
    
    BlocTalkJSQMessage *message = self.conversationsList[cellIndexPath.row];
    
    NSString *filePath = [self pathForFilename:message.userID];
    
    NSString *newPath = [self pathForFilename:[NSString stringWithFormat:@"archiveFolder/%@",message.userID]];
    
    //NSLog(@"%@",newPath);
    
    NSError *error;
    
    //datasource
        BOOL test;
        
    test = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:newPath error:&error];
    
    if (error){
        NSLog(@"%@", error.localizedDescription);
    }
    

    [self.conversationsList removeObjectAtIndex:cellIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if ([self.conversationsList count] == 0){
        self.noMessage.hidden = FALSE;
    }
    
}

@end
