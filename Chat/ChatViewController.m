//
//  ChatViewController.m
//  Chat
//
//  Created by Puneet Makkar on 9/16/15.
//  Copyright © 2015 Puneet Makkar. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "MyTableViewCell.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) IBOutlet UILabel *welcome;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) NSArray *messageArray;

@end

@implementation ChatViewController
- (IBAction)onLogOut:(id)sender {
    [PFUser logOut];
     [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)onMessagePost:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        PFObject *message = [PFObject objectWithClassName:@"Message"];
        message[@"text"] = self.messageBox.text;
        message[@"user"] = currentUser;
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Message Posted");
                [self fetchMessages];
                [self.messageBox resignFirstResponder];
                self.messageBox.text = @"";
            } else {
               NSLog(@"Message not posted%@",error);
            }
        }];
    } else {
        NSLog(@"User not signed in");
    }
    
}

- (void) fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.messageArray = objects;
            NSLog(@"Successfully retrieved %lu messages.", (unsigned long)objects.count);
            [self.myTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSString *email = currentUser.email;
        NSString *welcome = @"Hi ";
        NSString *result = [welcome stringByAppendingString:email];
        self.welcome.text = result;
        [self fetchMessages];
    } else {
        NSLog(@"User not signed in");
    }
    
    
}

- (long)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Inside numberOfRowsInSection ");
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.example"];
    
    NSString *text = self.messageArray[indexPath.row][@"text"];
    if(!text) {
        text = @" ";
    }
    
    PFUser *user = self.messageArray[indexPath.row][@"user"];
    [user fetchIfNeeded];
    
    NSString *username = user.username;
    if(!username) {
        username = @"Anonymous";
    }
    
    NSString *sep = @": ";
    username = [username stringByAppendingString:sep];
    text = [username stringByAppendingString:text];
    
    cell.textLabel.text = text;
    
    if (indexPath.row % 2) {
        [cell setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
    }
    else {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
