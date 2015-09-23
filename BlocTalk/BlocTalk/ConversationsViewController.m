//
//  ConversationsViewController.m
//  BlocTalk
//
//  Created by Paulo Choi on 9/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "ConversationsViewController.h"

@interface ConversationsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;

@end

@implementation ConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //setting unicode settings icon to left navication button
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:26.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, NSFontAttributeName, nil];
    [self.settingButton setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
