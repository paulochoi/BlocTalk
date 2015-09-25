//
//  AvailableUsersTableViewCell.h
//  BlocTalk
//
//  Created by Paulo Choi on 9/25/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableUsersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
