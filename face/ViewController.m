//
//  ViewController.m
//  Tag
//
//  Created by Richard Robinson on 9/26/12.
//  Copyright (c) 2012 Richard Robinson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.authButtonAction setTitle:@"Logout" forState:UIControlStateNormal];
        self.userInfoTextView.hidden = NO;
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 //log output
                 [FBSettings setLoggingBehavior:[NSSet setWithObjects:
                                                 FBLoggingBehaviorFBRequests, nil]];
                 NSString *userInfo = @" ";
                 
                 
                 // Example: typed access (name)
                 // - no special permissions required
                 userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"Name: %@\n\n", user.name]];
                 
                 // Example: typed access, (birthday)
                 // - requires user_birthday permission
                 userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"Birthday: %@\n\n", user.birthday]];
                 
                 // Example: typed access, (email)
                 // - requires user_email permission
                 userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"Email: %@\n\n", [user objectForKey:@"email"]]];
                 
                 // Example: typed access, (education)
                 // - requires user_education_history permission
                 userInfo = [userInfo stringByAppendingString:[NSString stringWithFormat:@"Education: %@\n\n", [user objectForKey:@"education"]]];
                 
                 // Example: partially typed access, to location field,
                 // name key (location)
                 // - requires user_location permission
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Location: %@\n\n",
                              [user.location objectForKey:@"name"]]];
                 
                 // Example: access via key (locale)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Locale: %@\n\n",
                              [user objectForKey:@"locale"]]];
                 
                 // Example: access via key for array (languages)
                 // - requires user_likes permission
                 if ([user objectForKey:@"languages"]) {
                     NSArray *languages = [user objectForKey:@"languages"];
                     NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                     for (int i = 0; i < [languages count]; i++) {
                         [languageNames addObject:[[languages
                                                    objectAtIndex:i]
                                                   objectForKey:@"name"]];
                     }
                     userInfo = [userInfo
                                 stringByAppendingString:
                                 [NSString stringWithFormat:@"Languages: %@\n\n",
                                  languageNames]];
                 }
                 
                 // Display the user info
                 self.userInfoTextView.text = [NSString stringWithFormat:@"%@",  userInfo];
             }
         }];
    }else{
        [self.authButtonAction setTitle:@"Login with Facebook" forState:UIControlStateNormal];
        self.userInfoTextView.hidden = YES;
    }
}

//depricated need to fin a better way
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *Login button
 *
 */

- (IBAction)authButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}
@end
