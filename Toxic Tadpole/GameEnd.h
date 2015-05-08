//
//  GameEnd.h
//  Boing!
//
//  Created by Jacob Selmes on 20/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameKitHelper.h"



@interface GameEnd : SKScene

@property (nonatomic, assign) int type;
@property (nonatomic, strong) SKLabelNode *highScoreLabel;

-(id)initWithSize:(CGSize)size andScore:(int)theScore;
+(id)sceneWithSize:(CGSize)size andScore:(int)theScore;

@end
