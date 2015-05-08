//
//  GameKitHelper.h
//  CELLS
//
//  Created by Jacob Selmes on 15/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject <GKGameCenterControllerDelegate>

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
-(void)authenticateLocalPlayer;
-(void) submitScore:(int64_t)score category:(NSString*)category;
-(void) showLeaderboard;

@end
