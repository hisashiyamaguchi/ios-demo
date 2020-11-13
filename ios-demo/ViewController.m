//
//  ViewController.m
//  ios-demo
//
//  Created by Takashi Kamitsubo on 2020/07/14.
//  Copyright © 2020 Takashi Kamitsubo. All rights reserved.
//

#import "ViewController.h"
#import <AppAuth/AppAuth.h>
#import "AppDelegate.h"
#import <JWTDecode-Swift.h>
#import <AuthenticationServices/AuthenticationServices.h>

#define kClientID @"xxxx"
#define kAuthEndpoint @"https://v1.api.tk.janrain.com/xxxx/login/authorize"
#define kTokenEndpoint @"https://v1.api.tk.janrain.com/xxxx/login/token"
#define kLogoutEndpoint @"https://v1.api.tk.janrain.com/xxxx/auth-ui/logout?client_id=xxxx&redirect_uri=aic-demo://auth-callback"
#define kRedirectURI @"aic-demo://auth-callback"

@interface ViewController () <ASWebAuthenticationPresentationContextProviding>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic, strong) UILabel *contentView;
@property(nonatomic, strong, nullable) OIDAuthState *authState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.label.text = @"";
    self.loginButton.hidden = NO;
    self.logoutButton.hidden = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aic" ofType:@"plist"];
}



- (IBAction)loginButtonClicked:(UIButton *)sender {
    NSURL *authorizationEndpoint =
        [NSURL URLWithString:kAuthEndpoint];
    NSURL *tokenEndpoint =
        [NSURL URLWithString:kTokenEndpoint];

    OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc]
            initWithAuthorizationEndpoint:authorizationEndpoint
                            tokenEndpoint:tokenEndpoint];
    
    // builds authentication request
    OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientID
                                                        scopes:@[OIDScopeOpenID,
                                                                 OIDScopeProfile]
                                                   redirectURL:[NSURL URLWithString:kRedirectURI]
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];

    // performs authentication request
    AppDelegate *appDelegate =
        (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentAuthorizationFlow =
        [OIDAuthState authStateByPresentingAuthorizationRequest:request
            presentingViewController:self
                            callback:^(OIDAuthState *_Nullable authState,
                                       NSError *_Nullable error) {
      if (authState) {
          NSLog(@"Got authorization tokens.");
        [self setAuthState:authState];
          [self showTokenContents:authState.lastTokenResponse.idToken];
          NSLog(@"%@", authState.lastTokenResponse.accessToken);
          
          self.loginButton.hidden = YES;
          self.logoutButton.hidden = NO;
          self.logoutButton.center = self.loginButton.center;
      } else {
        NSLog(@"Authorization error: %@", [error localizedDescription]);
        [self setAuthState:nil];
      }
    }];
}

- (void)showTokenContents:(NSString *)token {
    OIDIDToken *idToken = [[OIDIDToken alloc] initWithIDTokenString:token];
    NSString *str = [NSString stringWithFormat:@"header:%@, claims:%@, issuer:%@, subject:%@, audience:%@, expiresAt:%@, issuedAt:%@, nonce:%@", idToken.header, idToken.claims, idToken.issuer, idToken.subject, idToken.audience, idToken.expiresAt, idToken.issuedAt, idToken.nonce];
    
    CGRect frame = self.label.frame;
    frame.size.height = 1000;
    self.label.frame = frame;
    
    self.label.text = str;
    
    self.scrollView.contentSize = self.label.frame.size;
}

- (ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(ASWebAuthenticationSession *)session {
    return self.view.window;
}

- (IBAction)logoutButtonClicked:(UIButton *)sender {
    ASWebAuthenticationSession *session = [[ASWebAuthenticationSession alloc] initWithURL:[NSURL URLWithString:kLogoutEndpoint]
                                                                        callbackURLScheme:kRedirectURI
                                                                        completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
        NSLog(@"callbackURL:%@", callbackURL);
        NSLog(@"error:%@", error);
        if (!error) {
            self.authState = nil;
            self.loginButton.hidden = NO;
            self.logoutButton.hidden = YES;
            self.label.text = @"";
        }
    }];
    session.presentationContextProvider = self;
    [session start];
}

@end
