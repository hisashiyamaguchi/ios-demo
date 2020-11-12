//
//  ViewController.h
//  ios-demo
//
//  Created by Takashi Kamitsubo on 2020/07/14.
//  Copyright © 2020 Takashi Kamitsubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)loginButtonClicked:(UIButton *)sender;
- (IBAction)logoutButtonClicked:(UIButton *)sender;


@end

