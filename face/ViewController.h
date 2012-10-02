//
//  ViewController.h
//  Tag
//
//  Created by Richard Robinson on 9/26/12.
//  Copyright (c) 2012 Richard Robinson. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface ViewController : UIViewController
- (IBAction)authButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *authButtonAction;
/*
 *Data returned
 *
 */
@property (weak, nonatomic) IBOutlet UITextView *userInfoTextView;

@end
