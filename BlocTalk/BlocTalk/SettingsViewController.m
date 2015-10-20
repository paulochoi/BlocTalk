//
//  SettingsViewController.m
//  BlocTalk
//
//  Created by Paulo Choi on 10/18/15.
//  Copyright © 2015 Paulo Choi. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;


@end

@implementation SettingsViewController

- (IBAction)saveInfo:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameLabel.text forKey:@"UserDisplayName"];
    
    NSString *imageHash = [NSString stringWithFormat:@"avatars/%lu",[self.avatarImage.imageView.image hash]];
    
    
    NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:imageHash];
    
    [UIImagePNGRepresentation(self.avatarImage.imageView.image) writeToFile:documentsDirectory atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject: imageHash forKey:@"userAvatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickAvatar:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"UserDisplayName"]];
    
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userAvatar"]);
    
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userAvatar"]){
        
        NSString* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAvatar"];
        
        NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:imageData];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage* image = [UIImage imageWithContentsOfFile:documentsDirectory];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.avatarImage setImage:image forState:UIControlStateNormal];
            });
        });
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage *myImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.avatarImage setImage:myImage forState:UIControlStateNormal];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveProfile:(id)sender {
}
@end
