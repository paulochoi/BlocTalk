//
//  CurrentConversationsTableViewCell.h
//  BlocTalk
//
//  Created by Paulo Choi on 10/8/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentConversationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textPreview;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
