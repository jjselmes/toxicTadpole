//
//  GameEnd.h
//  Boing!
//
//  Created by Jacob Selmes on 20/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameEnd : SKScene

-(id)initWithSize:(CGSize)size andScore:(int)theScore;
+(id)sceneWithSize:(CGSize)size andScore:(int)theScore;

@end
