//
//  AppDelegate.h
//  ios-demo
//
//  Created by Takashi Kamitsubo on 2020/07/14.
//  Copyright © 2020 Takashi Kamitsubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppAuth/AppAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;

@end

