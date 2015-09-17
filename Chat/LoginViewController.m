//
//  LoginViewController.m
//  Chat
//
//  Created by Puneet Makkar on 9/16/15.
//  Copyright © 2015 Puneet Makkar. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ChatViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    self.password.text = @"";
    self.email.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnSignUp:(id)sender {
    
    PFUser *user = [PFUser user];
    self.errorMessage.text = @"";
    
    user.password = self.password.text;
    user.email = self.email.text;
    user.username = self.email.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSLog(@"SignUp Successfull");
            [self performSegueWithIdentifier:@"SignInSegue" sender:sender];
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString
            self.errorMessage.text = @"Invalid Details. Please try again";
            NSLog(@"SignUp Error %@",error);
        }
    }];
}

- (IBAction)onSignin:(id)sender {
    
    NSString *user = self.email.text;
    NSString *pass = self.password.text;
    self.errorMessage.text = @"";
    
    [PFUser logInWithUsernameInBackground:user password:pass
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                           NSLog(@"Login Successfull");
                                            [self performSegueWithIdentifier:@"SignInSegue" sender:sender];
                                        } else {
                                            self.errorMessage.text = @"Invalid Login. Please try again";
                                            NSLog(@"Login Error");
                                        }
                                    }];
}
@end
