//
//  GameKitHelper.m
//  CELLS
//
//  Created by Jacob Selmes on 15/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import "GameKitHelper.h"

@implementation GameKitHelper
BOOL _enableGameCenter;

NSString *const PresentAuthenticationViewController = @"present_authenication_view_controller";

-(id)init {
    self = [super init];
    if(self) {
        _enableGameCenter = YES;
    }
    return self;
}

+(instancetype)sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedGameKitHelper = [[GameKitHelper alloc]init];
    });
    return sharedGameKitHelper;
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        if (viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
        } else {
            _enableGameCenter = NO;
        }
    };
}

-(void)submitScore:(int64_t)score category:(NSString *)category {
    if(!_enableGameCenter) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    
    GKScore *gkScore = [[GKScore alloc]initWithLeaderboardIdentifier:@"toxicLeaderboard1"];
    
    gkScore.value = score;
    
    [GKScore reportScores:@[gkScore] withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
        
        
    }];
    
}

-(UIViewController*) getRootController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController *rootVC = [self getRootController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}

-(void)showLeaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc]init];
    if(gameCenterController!=nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gameCenterController];
    }
}

-(void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    if (authenticationViewController !=nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
    }
}
-(void)setLastError:(NSError *)lastError {
    _lastError = [lastError copy];
    if (_lastError) {
        NSLog(@"GKH error %@",[[_lastError userInfo] description]);
    }
}

@end
