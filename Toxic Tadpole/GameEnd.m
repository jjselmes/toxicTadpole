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



+(id)sceneWithSize:(CGSize)size andScore:(int)theScore
{
    return [[self alloc]initWithSize:size andScore:theScore];
}

-(id)initWithSize:(CGSize)size andScore:(int)theScore {
    if (self = [super initWithSize:size]) {
        
        
        
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    CGRect size = [[UIScreen mainScreen] bounds];
    
    
    
    NSString *levelOne = @"To Levels";
    SKLabelNode *labelOne = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelOne.text = levelOne;
    labelOne.fontSize = 20;
    labelOne.fontColor = [SKColor whiteColor];
    labelOne.position=CGPointMake(size.size.width*0.5f, size.size.height*0.7f);
    labelOne.name=@"ToLevels";
    [self addChild:labelOne];
    
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    NSInteger latestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentScore"];
    
    
    
    if (latestScore == highScore) {
        SKLabelNode *new = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        new.text = @"New High Score";
        new.fontSize = 20;
        new.fontColor = [SKColor redColor];
        new.position=CGPointMake(size.size.width*0.5f, size.size.height*0.5f);
        new.zPosition = 10;
        [self addChild:new];
        //[[GameKitHelper sharedGameKitHelper] submitScore:highScore category:@"cell_leaderboard"];
    }
    
    
    SKLabelNode *latestLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    latestLabel.text = @"Latest Score";
    latestLabel.fontSize = 20;
    latestLabel.fontColor = [SKColor redColor];
    latestLabel.position=CGPointMake(size.size.width*0.5f, size.size.height*0.3f);
    latestLabel.zPosition = 10;
    [self addChild:latestLabel];
    
    SKLabelNode *labelTwo = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelTwo.text = [NSString stringWithFormat:@"%li",(long)latestScore];
    labelTwo.fontSize = 20;
    labelTwo.fontColor = [SKColor redColor];
    labelTwo.position=CGPointMake(size.size.width*0.5f, size.size.height*0.25f);
    labelTwo.zPosition = 10;
    [self addChild:labelTwo];
    
    SKLabelNode *highLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highLabel.text = @"High Score";
    highLabel.fontSize = 20;
    highLabel.fontColor = [SKColor redColor];
    highLabel.position=CGPointMake(size.size.width*0.5f, size.size.height*0.2f);
    highLabel.zPosition = 10;
    [self addChild:highLabel];
    
    SKLabelNode *labelT = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelT.text = [NSString stringWithFormat:@"%li",(long)highScore];
    labelT.fontSize = 20;
    labelT.fontColor = [SKColor redColor];
    labelT.position=CGPointMake(size.size.width*0.5f, size.size.height*0.15f);
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
    
    
    
    
    
}


@end
