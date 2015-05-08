//
//  GameEnd.m
//  Boing!
//
//  Created by Jacob Selmes on 20/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import "GameEnd.h"
#import "GameScene.h"

@implementation GameEnd

@synthesize type;
@synthesize highScoreLabel;

+(id)sceneWithSize:(CGSize)size andScore:(int)theScore
{
    return [[self alloc]initWithSize:size andScore:theScore];
}

-(id)initWithSize:(CGSize)size andScore:(int)theScore {
    if (self = [super initWithSize:size]) {
        
        
        type = theScore;    // 0 is main and 1 is end
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    CGRect size = [[UIScreen mainScreen] bounds];
    
    self.backgroundColor = [UIColor colorWithRed:30/255.0f green:144/255.0f blue:1.0f alpha:1.0f];
    
    SKSpriteNode *tadpole = [SKSpriteNode spriteNodeWithImageNamed:@"menuTadpole"];
    tadpole.position = CGPointMake(size.size.width*0.75f, size.size.height*0.4f);
    [self addChild:tadpole];
    
    SKSpriteNode *barrel = [SKSpriteNode spriteNodeWithImageNamed:@"barrel"];
    barrel.position = CGPointMake(size.size.width*0.1f, size.size.height*0.25f);
    barrel.zRotation = 0.5f;
    [self addChild:barrel];
    
    SKSpriteNode *leaves = [SKSpriteNode spriteNodeWithImageNamed:@"foreGround1"];
    leaves.position = CGPointMake(size.size.width*0.5f, size.size.height*0.5f);
    [self addChild:leaves];
    
    SKSpriteNode *name = [SKSpriteNode spriteNodeWithImageNamed:@"name"];
    name.position = CGPointMake(size.size.width*0.5f, size.size.height*0.8f);
    [self addChild:name];
    
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    play.position = CGPointMake(size.size.width*0.5f, size.size.height*0.5f);
    play.name=@"ToLevels";
    [self addChild:play];
    
    SKSpriteNode *gc = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenter"];
    gc.position = CGPointMake(size.size.width*0.925f, size.size.height*0.1f);
    gc.name = @"LEADERBOARD";
    [self addChild:gc];
    
    
    
    
   
    
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    NSInteger latestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentScore"];
    
    
    if (type == 1) {
        if (latestScore == highScore) {
            highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
            highScoreLabel.text = @"New High Score!!";
            highScoreLabel.fontSize = 20;
            highScoreLabel.fontColor = [SKColor colorWithRed:1 green:0 blue:1 alpha:1];
            highScoreLabel.position=CGPointMake(size.size.width*0.5f, size.size.height*0.31f);
            highScoreLabel.zPosition = 10;
            [self addChild:highScoreLabel];
            SKAction *fadeDown = [SKAction fadeAlphaTo:0 duration:0.1f];
            SKAction *fadeUp = [SKAction fadeAlphaTo:1 duration:0.2f];
            SKAction *seq = [SKAction repeatActionForever:[SKAction sequence:@[fadeDown, fadeUp]]];
            [highScoreLabel runAction:seq];
            [[GameKitHelper sharedGameKitHelper] submitScore:highScore category:@"toxicLeaderboard1"];
            //[[GameKitHelper sharedGameKitHelper] submitScore:highScore category:@"cell_leaderboard"];
        }
    }
    
   
    
    SKLabelNode *latestLabel = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
    latestLabel.text = @"Latest Score";
    latestLabel.fontSize = 16;
    latestLabel.fontColor = [SKColor colorWithRed:1 green:0 blue:1 alpha:1];;
    latestLabel.position=CGPointMake(size.size.width*0.4f, size.size.height*0.2f);
    latestLabel.zPosition = 10;
    [self addChild:latestLabel];
    
    SKLabelNode *labelTwo = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
    labelTwo.text = [NSString stringWithFormat:@"%li",(long)latestScore];
    labelTwo.fontSize = 16;
    labelTwo.fontColor = [SKColor colorWithRed:1 green:0 blue:1 alpha:1];;
    labelTwo.position=CGPointMake(latestLabel.position.x + 0.7f*latestLabel.frame.size.width, size.size.height*0.2f);
    labelTwo.zPosition = 10;
    [self addChild:labelTwo];
    
    if (type == 0) {
        latestLabel.hidden = YES;
        labelTwo.hidden = YES;
    }

    
    
    
    SKLabelNode *highLabel = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
    highLabel.text = @"High Score";
    highLabel.fontSize = 16;
    highLabel.fontColor = [SKColor colorWithRed:1 green:0 blue:1 alpha:1];
    highLabel.position=CGPointMake(size.size.width*0.4f - (latestLabel.frame.size.width*0.5f - highLabel.frame.size.width*0.5f), size.size.height*0.1f);
    highLabel.zPosition = 10;
    [self addChild:highLabel];
    
    SKLabelNode *labelT = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
    labelT.text = [NSString stringWithFormat:@"%li",(long)highScore];
    labelT.fontSize = 16;
    labelT.fontColor = [SKColor colorWithRed:1 green:0 blue:1 alpha:1];
    labelT.position = CGPointMake(labelTwo.position.x, size.size.height*0.1f);
    labelT.zPosition  = 10;
    [self addChild:labelT];
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node.name isEqualToString:@"ToLevels"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:1];
        GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
    
    if([node.name isEqualToString:@"LEADERBOARD"]) {
        [[GameKitHelper sharedGameKitHelper] showLeaderboard];
    }
    
    
    
    
    
}


@end
