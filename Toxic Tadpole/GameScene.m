//
//  GameScene.m
//  Boing!
//
//  Created by Jacob Selmes on 19/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import "GameScene.h"
#import "GameEnd.h"

@implementation GameScene

@synthesize winSize;
@synthesize player;

@synthesize start;
@synthesize now;
@synthesize flowSpeed;
@synthesize floor;
@synthesize floor2;
@synthesize roof;
@synthesize roof2;
@synthesize middleHit;
@synthesize previousContent;
@synthesize floorHit;
@synthesize touching;
@synthesize trajectory;
@synthesize originalY;
@synthesize score;
@synthesize scoreLabel;
@synthesize doneBlocks;
@synthesize inAir;
@synthesize onGround;
@synthesize touchEnded;
@synthesize contentCounter;
@synthesize originalPlayerSize;
@synthesize reverseCounter;
@synthesize isDead;
@synthesize background;
@synthesize background2;
@synthesize midground;
@synthesize midground2;
@synthesize foreground;
@synthesize foreground2;
@synthesize travellingFrames;
@synthesize landingFrames;
@synthesize jumpingFrames;
@synthesize squishingFrames;
@synthesize STATE;
@synthesize previousState;
@synthesize currentVelocityY;
@synthesize previousVelocityY;
@synthesize setBodyToNormal;
@synthesize thePhysicsBodies;


+(id)sceneWithSize:(CGSize)size
{
    return [[self alloc]initWithSize:size];
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        STATE = TRAVEL;
        thePhysicsBodies = [NSMutableDictionary dictionary];
        setBodyToNormal = NO;
        previousState = LAND;
        currentVelocityY = 0.0f;
        previousVelocityY = 0.0f;
        winSize = size;
        touchEnded = NO;
        reverseCounter = 0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            flowSpeed = 3.0f;
        } else {
            flowSpeed = 5.4f;
        }
        isDead = NO;
        inAir = NO;
        onGround = YES;
        touching = NO;
        originalY = 0.0f;
        score = 0;
        contentCounter = 0;
        doneBlocks = [NSMutableArray array];
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"WOBBLES"];
        scoreLabel.text = [NSString stringWithFormat:@"%li",(long)score];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            scoreLabel.fontSize = 16;
        } else {
            scoreLabel.fontSize = 32;
        }
        scoreLabel.fontColor = [UIColor blackColor];
        scoreLabel.position = CGPointMake(winSize.width*0.1f, winSize.height*0.9f);
        scoreLabel.zPosition = 10;
        [self addChild:scoreLabel];
        previousContent = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithRed:0.3f green:0.7f blue:1.0f alpha:1.0f];
        self.physicsWorld.contactDelegate = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.physicsWorld.gravity = CGVectorMake(0,-9.8);
        } else {
            self.physicsWorld.gravity = CGVectorMake(0,-9.8);
        }
        
        floorHit = NO;
        CGPoint location = CGPointMake(size.width*0.5f, size.height*0.5f);
        CGPoint location2 = CGPointMake(size.width*1.5f, size.height*0.5f);
        SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"backGround1"];
        background = [SKSpriteNode spriteNodeWithTexture:bgTexture];
        background.position = location;
        background.zPosition = -3;
        [self addChild:background];
        SKTexture *bgTexture2 = [SKTexture textureWithImageNamed:@"backGround2"];
        background2 = [SKSpriteNode spriteNodeWithTexture:bgTexture2];
        background2.position = location2;
        background2.zPosition = -3;
        [self addChild:background2];
        
        CGPoint location3 = CGPointMake(size.width*0.5f, size.height*0.5f);
        CGPoint location4 = CGPointMake(size.width*1.5f, size.height*0.5f);
        SKTexture *bgTexture1 = [SKTexture textureWithImageNamed:@"midGround1"];
        midground = [SKSpriteNode spriteNodeWithTexture:bgTexture1];
        midground.position = location3;
        midground.zPosition = -2;
        [self addChild:midground];
        SKTexture *bgTexture3 = [SKTexture textureWithImageNamed:@"midGround2"];
        midground2 = [SKSpriteNode spriteNodeWithTexture:bgTexture3];
        midground2.position = location4;
        midground2.zPosition = -2;
        [self addChild:midground2];
        
        {
            
            CGPoint fglocation1 = CGPointMake(size.width*0.5f, size.height*0.5f);
            CGPoint fglocation2 = CGPointMake(size.width*1.5f, size.height*0.5f);
            SKTexture *fgTexture1 = [SKTexture textureWithImageNamed:@"foreGround1"];
            foreground = [SKSpriteNode spriteNodeWithTexture:fgTexture1];
            foreground.position = fglocation1;
            foreground.zPosition = 7;
            [self addChild:foreground];
            SKTexture *fgTexture2 = [SKTexture textureWithImageNamed:@"foreGround2"];
            foreground2 = [SKSpriteNode spriteNodeWithTexture:fgTexture2];
            foreground2.position = fglocation2;
            foreground2.zPosition = 7;
            [self addChild:foreground2];
            
        }
        [self setUpScene];
        
        //NSLog(@"end of iniy: %f",flowSpeed);
    }
    return self;
}

-(void)setUpScene {
    SKTexture *floorTex = [SKTexture textureWithImageNamed:@"floor1.png"];
    
    floor = [SKSpriteNode spriteNodeWithTexture:floorTex];
    floor.name=@"floor";
    floor.position = CGPointMake(winSize.width*0.5f, winSize.height*0.2f);
    floor.zPosition = 5;
    floor.physicsBody = [SKPhysicsBody bodyWithTexture:floorTex alphaThreshold:0.99f size:floorTex.size];
    floor.physicsBody.dynamic=NO;
    floor.physicsBody.affectedByGravity=NO;
    floor.physicsBody.mass=4;
    floor.physicsBody.restitution = 0.0f;
    floor.physicsBody.linearDamping=0.0f;
    floor.physicsBody.categoryBitMask = floorCategory;
    floor.physicsBody.collisionBitMask = playerCategory | sceneCategory;
    floor.physicsBody.contactTestBitMask = playerCategory | floorCategory | sceneCategory;
    [self addChild:floor];
    
    floor2 = [SKSpriteNode spriteNodeWithImageNamed:@"floor2.png"];
    
    travellingFrames = [NSMutableArray array];
    NSMutableArray *travelFrames = [NSMutableArray array];
    
    SKTextureAtlas *travelAtlas = [SKTextureAtlas atlasNamed:@"movingIphone"];
    SKTextureAtlas *landAtlas = [SKTextureAtlas atlasNamed:@"landingIphone"];
    SKTextureAtlas *jumpAtlas = [SKTextureAtlas atlasNamed:@"jumpIphone"];
    SKTextureAtlas *squishAtlas = [SKTextureAtlas atlasNamed:@"squishIphone"];
    
    
    int travelImages = (int)travelAtlas.textureNames.count;
    for (int i=1;i<=(travelImages/2);i++) {
        NSString *texturename = [NSString stringWithFormat:@"player%d",i];
        SKTexture *temp = [travelAtlas textureNamed:texturename];
        [travelFrames addObject:temp];
    }
    travellingFrames = travelFrames;
    
    landingFrames = [NSMutableArray array];
    NSMutableArray *landFrames = [NSMutableArray array];
    
    int landImages = (int)landAtlas.textureNames.count;
    for (int i=1;i<=landImages;i++) {
        NSString *texturename = [NSString stringWithFormat:@"landing%d",i];
        SKTexture *temp = [landAtlas textureNamed:texturename];
        [landFrames addObject:temp];
    }
    landingFrames = landFrames;
    
    jumpingFrames = [NSMutableArray array];
    NSMutableArray *jumpFrames = [NSMutableArray array];
    
    int jumpImages = (int)jumpAtlas.textureNames.count;
    for (int i=1;i<=jumpImages;i++) {
        NSString *texturename = [NSString stringWithFormat:@"jump%d",i];
        SKTexture *temp = [jumpAtlas textureNamed:texturename];
        [jumpFrames addObject:temp];
    }
    jumpingFrames = jumpFrames;
    
    squishingFrames = [NSMutableArray array];
    NSMutableArray *squishFrames = [NSMutableArray array];
    
    int squishImages = (int)squishAtlas.textureNames.count;
    for (int i=1;i<squishImages/2;i++) {
        NSString *texturename = [NSString stringWithFormat:@"squish%d",i];
        SKTexture *temp = [squishAtlas textureNamed:texturename];
        [squishFrames addObject:temp];
    }
    squishingFrames = squishFrames;
    
    
    
    player = [SKSpriteNode spriteNodeWithTexture:travellingFrames[0]];
    originalPlayerSize = player.frame.size;
    player.name = @"player";
    player.zPosition = 5;
    //player.anchorPoint = CGPointMake(0.5f, 0);
    player.position = CGPointMake(winSize.width*0.333f, floor.position.y + floor.frame.size.height*0.5f + originalPlayerSize.height*0.49f);
    originalY = player.position.y;
    
    
    
    
    NSString *texturename = @"player1";
    
    SKTexture *temp = [travelAtlas textureNamed:texturename];
    
    player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
    [thePhysicsBodies setObject:player.physicsBody forKey:@"TRAVEL"];
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    
    player.physicsBody.mass=1;
    
        
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
    [self addChild:player];
    
    [player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:travellingFrames timePerFrame:0.1f resize:YES restore:YES]]];
    
    // Background layers and first lot of surfaces.
    
    
    
    floor2.name=@"floor";
    floor2.position = CGPointMake(winSize.width*1.5f, winSize.height*0.2f);
    floor2.zPosition = 5;
    floor2.physicsBody = [SKPhysicsBody bodyWithTexture:floorTex alphaThreshold:0.99f size:floorTex.size];
    floor2.physicsBody.dynamic=NO;
    floor2.physicsBody.affectedByGravity=NO;
    floor2.physicsBody.mass=4;
    floor2.physicsBody.restitution = 0.0f;
    floor2.physicsBody.linearDamping=0.0f;
    floor2.physicsBody.categoryBitMask = floorCategory;
    floor2.physicsBody.collisionBitMask = playerCategory | sceneCategory;
    floor2.physicsBody.contactTestBitMask = playerCategory | floorCategory | sceneCategory;
    [self addChild:floor2];
    
    floor.physicsBody.usesPreciseCollisionDetection = YES;
    floor2.physicsBody.usesPreciseCollisionDetection = YES;
    
    roof = [SKSpriteNode spriteNodeWithImageNamed:@"floor1.png"];
    roof.name=@"roof";
    roof.zPosition = 5;
    roof.position = CGPointMake(winSize.width*0.5f, winSize.height*0.85f);
    roof.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:roof.frame.size];
    roof.physicsBody.dynamic=NO;
    roof.physicsBody.affectedByGravity=NO;
    roof.physicsBody.mass=4;
    roof.physicsBody.restitution = 0.0f;
    roof.physicsBody.linearDamping=0.0f;
    roof.physicsBody.categoryBitMask = floorCategory;
    roof.physicsBody.collisionBitMask = floorCategory | playerCategory | sceneCategory;
    roof.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory;
    [self addChild:roof];
    
    roof2 = [SKSpriteNode spriteNodeWithImageNamed:@"floor2.png"];
    roof2.name=@"roof";
    roof2.zPosition = 5;
    roof2.position = CGPointMake(winSize.width*1.5f, winSize.height*0.85f);
    roof2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:roof2.frame.size];
    roof2.physicsBody.dynamic=NO;
    roof2.physicsBody.affectedByGravity=NO;
    roof2.physicsBody.mass=4;
    roof2.physicsBody.restitution = 0.0f;
    roof2.physicsBody.linearDamping=0.0f;
    roof2.physicsBody.categoryBitMask = floorCategory;
    roof2.physicsBody.collisionBitMask = floorCategory | playerCategory | sceneCategory;
    roof2.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory;
    [self addChild:roof2];

       
    [self contentTwo];
}

-(void)didMoveToView:(SKView *)view {
    
}



-(float)randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}



-(void)contentOne {
    SKTexture *blockTex = [SKTexture textureWithImageNamed:@"block1.png"];
    SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:blockTex];
    block.name = @"block";
    block.zPosition = 6;
    if (self.physicsWorld.gravity.dy < 0) {
        CGFloat startY = (floor.position.y + floor.frame.size.height*0.5f) + player.frame.size.height - block.frame.size.height*0.5f;
        CGFloat endY = roof.position.y - roof.frame.size.height*0.5f - player.frame.size.height*2.0f - block.frame.size.height*0.5f;
        CGFloat posY = [self randFloatBetween:startY and:endY];
        block.position = CGPointMake(winSize.width*1.6f, posY);
        //block.anchorPoint = CGPointMake(0.5f, 1.0f);
        block.physicsBody = [SKPhysicsBody bodyWithTexture:blockTex size:block.frame.size];
    } else {
        CGFloat startY = roof.position.y - roof.frame.size.height*0.5f - player.frame.size.height + block.frame.size.height*0.5f;
        CGFloat endY = floor.position.y + floor.frame.size.height*0.5f + player.frame.size.height*2.0f + block.frame.size.height*0.5f;
        CGFloat posY = [self randFloatBetween:endY and:startY];
        block.position = CGPointMake(winSize.width*1.6f, posY);
        //block.anchorPoint = CGPointMake(0.5f, 0);
        block.physicsBody = [SKPhysicsBody bodyWithTexture:blockTex size:block.frame.size];
    }
    
    
    block.physicsBody.dynamic=NO;
    block.physicsBody.affectedByGravity=NO;
    block.physicsBody.mass=4;
    block.physicsBody.restitution = 0.5f;
    block.physicsBody.linearDamping=0.0f;
    block.physicsBody.categoryBitMask = blockCategory;
    block.physicsBody.collisionBitMask = playerCategory | floorCategory;
    block.physicsBody.contactTestBitMask = floorCategory | playerCategory;
    [self addChild:block];
}

-(void)contentTwo {
    // BOTTOM BLOCK
    SKTexture *blockTex = [SKTexture textureWithImageNamed:@"block1.png"];
    SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:blockTex];
    block.name = @"block";
    block.zPosition = 6;
    CGFloat startY = floor.position.y + (floor.frame.size.height*0.5f) + (player.frame.size.height*1.0f);
    CGFloat endY = ((roof.position.y - floor.position.y) * 0.6f) + floor.position.y;
    CGFloat posY = [self randFloatBetween:startY and:endY] - block.frame.size.height*0.5f;
    block.position = CGPointMake(winSize.width*1.6f, posY);
    
    block.physicsBody = [SKPhysicsBody bodyWithTexture:blockTex size:block.frame.size];
    block.physicsBody.dynamic=NO;
    block.physicsBody.affectedByGravity=NO;
    block.physicsBody.mass=4;
    block.physicsBody.restitution = 0.5f;
    block.physicsBody.linearDamping=0.0f;
    block.physicsBody.categoryBitMask = blockCategory;
    block.physicsBody.collisionBitMask = playerCategory | floorCategory;
    block.physicsBody.contactTestBitMask = floorCategory | playerCategory;
    [self addChild:block];
    
    // TOP BLOCK
    SKSpriteNode *block1 = [SKSpriteNode spriteNodeWithTexture:blockTex];
    block1.name = @"block";
    block1.zPosition = 6;
    
    CGFloat posY1 = block.position.y + block.frame.size.height + player.frame.size.height*2.0f;
    block1.position = CGPointMake(winSize.width*1.6f, posY1);
    //block1.anchorPoint = CGPointMake(0.5f, 0);
    block1.physicsBody = [SKPhysicsBody bodyWithTexture:blockTex size:block.frame.size];
    block1.physicsBody.dynamic=NO;
    block1.physicsBody.affectedByGravity=NO;
    block1.physicsBody.mass=4;
    block1.physicsBody.restitution = 0.5f;
    block1.physicsBody.linearDamping=0.0f;
    block1.physicsBody.categoryBitMask = blockCategory;
    block1.physicsBody.collisionBitMask = playerCategory | floorCategory;
    block1.physicsBody.contactTestBitMask = floorCategory | playerCategory;
    [self addChild:block1];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setStateSquish];
    if (self.physicsWorld.gravity.dy<0) {
        if (player.position.y - (floor.frame.size.height*0.5f) - (floor.position.y) < player.frame.size.height*0.55f) {
            player.physicsBody.dynamic = YES;
            touching = YES;
            start = [NSDate date];
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if ([[NSString stringWithFormat:@"%@",firstBody.node.name] isEqualToString:@"player"] &&
        [[NSString stringWithFormat:@"%@",secondBody.node.name] isEqualToString:@"block"]) {
        
        //self.paused = YES;
        NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        if (score>highScore) {
            [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"OldHighScore"];
            [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"HighScore"];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"CurrentScore"];
        isDead = YES;
        self.physicsWorld.speed = 0;
        SKTransition *reveal = [SKTransition fadeWithDuration:1];
        SKScene * scene = [GameEnd sceneWithSize:winSize andScore:1];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKView *skView = (SKView *) self.view;
        [skView presentScene:scene transition:reveal];
    }
    if ([[NSString stringWithFormat:@"%@",secondBody.node.name] isEqualToString:@"player"] &&
        [[NSString stringWithFormat:@"%@",firstBody.node.name] isEqualToString:@"block"]) {
        NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        if (score>highScore) {
            [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"OldHighScore"];
            [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"HighScore"];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"CurrentScore"];
        isDead = YES;
        self.physicsWorld.speed = 0;
        SKTransition *reveal = [SKTransition fadeWithDuration:1];
        SKScene * scene = [GameEnd sceneWithSize:winSize andScore:1];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKView *skView = (SKView *) self.view;
        [skView presentScene:scene transition:reveal];
    }
    
    if ([[NSString stringWithFormat:@"%@",firstBody.node.name] isEqualToString:@"player"] &&
        [[NSString stringWithFormat:@"%@",secondBody.node.name] isEqualToString:@"floor"] && STATE!=LAND && STATE==FLY_DOWN) {
        inAir = NO;
        if (STATE != LAND) {
            [self setStateLand];
            
            
        }

    }
    if ([[NSString stringWithFormat:@"%@",secondBody.node.name] isEqualToString:@"player"] &&
        [[NSString stringWithFormat:@"%@",firstBody.node.name] isEqualToString:@"floor"] && STATE!=LAND && STATE==FLY_DOWN) {
        inAir = NO;
        if (STATE != LAND) {
            [self setStateLand];
            
        }
    }
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setStateJump];
    touching = NO;
    touchEnded = YES;
    [player removeAllActions];
    SKAction *squash = [SKAction scaleYTo:1.0f duration:0.2f];
    [player runAction:squash];
    player.physicsBody.dynamic = YES;
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    timeInterval*=-1;
    // So time interval from 0 upwards with 1 second being the max force allowed
    if (timeInterval>0.8f) {
        timeInterval=0.8f;
    }
    timeInterval/=0.8f;
    // o to 1 seconds is 0 to 90 degrees.
    // Then convert to radians.
    timeInterval*=90;
    CGFloat angle = (timeInterval*M_PI)/180.0f;
    CGFloat multiplier = 0.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        multiplier = 640.0f;
    } else {
        multiplier = 640.0f * 1.6f;
    }
    
    flowSpeed = 5.0f;
    
    CGFloat verticalImpulse = multiplier*sinf(angle);
    if (self.physicsWorld.gravity.dy>0) {
        verticalImpulse*=-1;
    }
    //NSLog(@"vert impulse: %f",verticalImpulse);
    CGVector impulse = CGVectorMake(0,verticalImpulse);
    [player.physicsBody applyImpulse:impulse];
}

-(void)nextContent {
    int rnd = 0;
    rnd = arc4random()%4;
    switch (rnd) {
        case 0:
            [self contentOne];
            break;
        case 1:
            [self contentTwo];
            break;
        case 2:
            [self contentTwo];
            break;
        case 3:
            [self contentTwo];
            break;
            
    }
}

-(void)setStateSquish {
    [player removeAllActions];
    [player runAction:[SKAction animateWithTextures:squishingFrames timePerFrame:((1.0f/12)*0.8f) resize:YES restore:NO]];
    previousState = TRAVEL;
    STATE = SQUISH;
    //NSLog(@"now: %i and previous: %i",STATE,previousState);
    SKTexture *temp = player.texture;
    if ([thePhysicsBodies objectForKey:@"SQUISH"]) {
        player.physicsBody = [thePhysicsBodies objectForKey:@"SQUISH"];
    } else {
        player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
        [thePhysicsBodies setObject:player.physicsBody forKey:@"SQUISH"];
    }
    
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    player.physicsBody.mass=1;
    

    
    
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
}

-(void)setStateJump {
    [player removeAllActions];
    previousState = SQUISH;
    STATE = JUMP;
    [self setStateFlyUp];
    
}

-(void)setStateFlyUp {
    [player removeAllActions];
    SKTexture *flyTex = [SKTexture textureWithImageNamed:@"fly"];
    [player setTexture:flyTex];
    player.size = flyTex.size;
    previousState = JUMP;
    STATE = FLY_UP;
    //NSLog(@"now: %i and previous: %i",STATE,previousState);
    if ([thePhysicsBodies objectForKey:@"FLY_UP"]) {
        player.physicsBody = [thePhysicsBodies objectForKey:@"FLY_UP"];
    } else {
        SKTexture *temp = player.texture;
        player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
        [thePhysicsBodies setObject:player.physicsBody forKey:@"FLY_UP"];
    }
    
    
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    
    player.physicsBody.mass=1;
        
    
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
}

-(void)setStateTop {
    [player removeAllActions];
    previousState = FLY_UP;
    STATE = TOP;
}

-(void)setStateFlyDown {
    [player removeAllActions];
    previousState = TOP;
    STATE = FLY_DOWN;
    //NSLog(@"now: %i and previous: %i",STATE,previousState);
    if ([thePhysicsBodies objectForKey:@"FLY_DOWN"]) {
        player.physicsBody = [thePhysicsBodies objectForKey:@"FLY_DOWN"];
    } else {
        SKTexture *temp = player.texture;
        player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
        [thePhysicsBodies setObject:player.physicsBody forKey:@"FLY_DOWN"];
    }
    
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    
    player.physicsBody.mass=1;
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
}

-(void)setStateLand {
    [player removeAllActions];
    SKAction *rotateDown = [SKAction rotateToAngle:0.0f duration:0.0f];
    
    SKAction *setToTravel = [SKAction runBlock: ^ {
        [self setStateToTravel];
    }];
    [player runAction:[SKAction sequence:@[rotateDown,[SKAction animateWithTextures:landingFrames timePerFrame:1.0f/92 resize:YES restore:NO], setToTravel]]];
    previousState = FLY_DOWN;
    STATE = LAND;
    if ([thePhysicsBodies objectForKey:@"LAND"]) {
        player.physicsBody = [thePhysicsBodies objectForKey:@"LAND"];
    } else {
        SKTexture *temp = player.texture;
        player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
        [thePhysicsBodies setObject:player.physicsBody forKey:@"LAND"];
    }
    
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    player.physicsBody.mass=1;
    
    
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
    
}

-(void)setStateToTravel {
    [player removeAllActions];
    
    previousState = LAND;
    STATE = TRAVEL;
    [player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:travellingFrames timePerFrame:0.1f resize:YES restore:YES]]];
    ///NSLog(@"now: %i and previous: %i",STATE,previousState);
    if ([thePhysicsBodies objectForKey:@"TRAVEL"]) {
        player.physicsBody = [thePhysicsBodies objectForKey:@"TRAVEL"];
    } else {
        SKTexture *temp = player.texture;
        player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
        [thePhysicsBodies setObject:player.physicsBody forKey:@"TRAVEL"];
    }
    
    player.physicsBody.dynamic=YES;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.physicsBody.affectedByGravity=YES;
    
    player.physicsBody.mass=1;
    
    
    
    
    player.physicsBody.restitution = 0.1f;
    player.physicsBody.linearDamping=0.0f;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
    player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
}

-(void)update:(CFTimeInterval)currentTime {
    //NSLog(@"start of update: %f",flowSpeed);
    //NSLog(@"State: %i",STATE);
    if (!isDead) {
        
        if (STATE == SQUISH) {
            //NSLog(@"now: %i and previous: %i",STATE,previousState);
            if ([thePhysicsBodies objectForKey:@"SQUISH"]) {
                player.physicsBody = [thePhysicsBodies objectForKey:@"SQUISH"];
                [thePhysicsBodies removeObjectForKey:@"SQUISH"];
            } else {
                SKTexture *temp = player.texture;
                player.physicsBody = [SKPhysicsBody bodyWithTexture:temp alphaThreshold:0.99f size:temp.size];
                [thePhysicsBodies setObject:player.physicsBody forKey:@"SQUISH"];
            }
            
            player.physicsBody.dynamic=YES;
            player.physicsBody.usesPreciseCollisionDetection = YES;
            player.physicsBody.affectedByGravity=YES;
            
            player.physicsBody.mass=1;
           
            
            player.physicsBody.restitution = 0.1f;
            player.physicsBody.linearDamping=0.0f;
            player.physicsBody.categoryBitMask = playerCategory;
            player.physicsBody.collisionBitMask = floorCategory | playerCategory | blockCategory | sceneCategory;
            player.physicsBody.contactTestBitMask = floorCategory | playerCategory | sceneCategory | blockCategory;
        }
        
        
        
        previousVelocityY = currentVelocityY;
        currentVelocityY = player.physicsBody.velocity.dy;
        //NSLog(@"prev: %f and curr: %f",previousVelocityY, currentVelocityY);
        if (previousVelocityY > 0 && currentVelocityY < 0 && STATE == FLY_UP) {
            NSLog(@"Starting down");
            SKAction *rotateDown = [SKAction rotateToAngle:-0.5f duration:0.25f];
            [player runAction:rotateDown];
            STATE = FLY_DOWN;
        }
        
        CGPoint backpos = background.position;
        CGPoint backpos2 = background2.position;
        if (background.position.x < background2.position.x) {
            backpos.x-=(0.2f*flowSpeed);
        } else {
            backpos2.x-=(0.2f*flowSpeed);
        }
        
        if (backpos.x < -0.5f*winSize.width) {
            backpos.x += 2.0f*winSize.width;
        }
        background.position = backpos;
        
        if (backpos2.x < -0.5f*winSize.width) {
            backpos2.x += 2.0f*winSize.width;
        }
        background2.position = backpos2;
        if (background.position.x < background2.position.x) {
            CGPoint backpos2 = background2.position;
            backpos2.x = background.position.x + background.frame.size.width;
            background2.position = backpos2;
        } else {
            CGPoint backpos1 = background.position;
            backpos1.x = background2.position.x + background2.frame.size.width;
            background.position = backpos1;
        }
        
        
        CGPoint midpos = midground.position;
        CGPoint midpos2 = midground2.position;
        if (midground.position.x < midground2.position.x) {
            midpos.x-=(0.5f*flowSpeed);
        } else {
            midpos2.x-=(0.5f*flowSpeed);
        }
        if (midpos.x < -0.5f*winSize.width) {
            midpos.x += 2.0f*winSize.width;
        }
        midground.position = midpos;
        if (midpos2.x < -0.5f*winSize.width) {
            midpos2.x += 2.0f*winSize.width;
        }
        midground2.position = midpos2;
        if (midground.position.x < midground2.position.x) {
            CGPoint midpos2 = midground2.position;
            midpos2.x = midground.position.x + midground.frame.size.width;
            midground2.position = midpos2;
        } else {
            CGPoint midpos1 = midground.position;
            midpos1.x = midground2.position.x + midground2.frame.size.width;
            midground.position = midpos1;
        }
        
        {
            CGPoint forepos = foreground.position;
            CGPoint forepos2 = foreground2.position;
            if (foreground.position.x < foreground2.position.x) {
                forepos.x-=(flowSpeed);
            } else {
                forepos2.x-=(flowSpeed);
            }
            if (forepos.x < -0.5f*winSize.width) {
                forepos.x += 2.0f*winSize.width;
            }
            foreground.position = forepos;
            if (forepos2.x < -0.5f*winSize.width) {
                forepos2.x += 2.0f*winSize.width;
            }
            foreground2.position = forepos2;
            if (foreground.position.x < foreground2.position.x) {
                CGPoint forepos2 = foreground2.position;
                forepos2.x = foreground.position.x + foreground.frame.size.width;
                foreground2.position = forepos2;
            } else {
                CGPoint forepos1 = foreground.position;
                forepos1.x = foreground2.position.x + foreground2.frame.size.width;
                foreground.position = forepos1;
            }
        }
        
        
        
        CGPoint floorpos = floor.position;
        CGPoint floorpos2 = floor2.position;
        if (floor.position.x < floor2.position.x) {
            floorpos.x-=(flowSpeed);
        } else {
            floorpos2.x-=(flowSpeed);
        }
        if (floorpos.x < -0.5f*winSize.width) {
            floorpos.x += 2.0f*winSize.width;
        }
        floor.position = floorpos;
        if (floorpos2.x < -0.5f*winSize.width) {
            floorpos2.x += 2.0f*winSize.width;
        }
        floor2.position = floorpos2;
        if (floor.position.x < floor2.position.x) {
            CGPoint floorpos2 = floor2.position;
            floorpos2.x = floor.position.x + floor.frame.size.width;
            floor2.position = floorpos2;
        } else {
            CGPoint floorpos1 = floor.position;
            floorpos1.x = floor2.position.x + floor2.frame.size.width;
            floor.position = floorpos1;
        }
        
        {
            CGPoint roofpos = roof.position;
            CGPoint roofpos2 = roof2.position;
            if (roof.position.x < roof2.position.x) {
                roofpos.x-=(flowSpeed);
            } else {
                roofpos2.x-=(flowSpeed);
            }
            if (roofpos.x < -0.5f*winSize.width) {
                roofpos.x += 2.0f*winSize.width;
            }
            roof.position = roofpos;
            if (roofpos2.x < -0.5f*winSize.width) {
                roofpos2.x += 2.0f*winSize.width;
            }
            roof2.position = roofpos2;
            if (roof.position.x < roof2.position.x) {
                CGPoint roofpos2 = roof2.position;
                roofpos2.x = roof.position.x + roof.frame.size.width;
                roof2.position = roofpos2;
            } else {
                CGPoint roofpos1 = roof.position;
                roofpos1.x = roof2.position.x + roof2.frame.size.width;
                roof.position = roofpos1;
            }
        }
        
        NSMutableArray *removeList = [NSMutableArray array];
        for (SKNode *node in [self children]) {
            if ([node.name isEqualToString:@"block"]) {
                CGPoint temp = node.position;
                temp.x -=flowSpeed;
                node.position = temp;
                if (temp.x < node.frame.size.width*-2.0f && temp.y < winSize.height*0.5f) {
                    [removeList addObject:node];
                } else if (((![doneBlocks containsObject:node]) && ((temp.x+node.frame.size.width*0.6f) < (player.position.x - player.frame.size.width*0.6f))) && (node.position.y < ((roof.position.y - floor.position.y)/2.0f))) {
                    score++;
                    [doneBlocks addObject:node];
                    scoreLabel.text = [NSString stringWithFormat:@"%li",(long)score];
                }
            }
            
        }
        if (removeList.count>0) {
            
            [self removeChildrenInArray:removeList];
            while (removeList.count>0) {
                SKNode *node = [removeList lastObject];
                node = nil;
                [removeList removeLastObject];
            }
        }
        
        contentCounter++;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (contentCounter==CONTENT_COUNT_LIMIT) {
                [self nextContent];
                //[self contentTwo];
                contentCounter = 0;
            }
        } else {
            if (contentCounter==CONTENT_COUNT_LIMIT_IPAD) {
                [self nextContent];
                //[self contentTwo];
                contentCounter = 0;
            }
        }
        
        
        if (STATE == LAND || STATE == TRAVEL || STATE == SQUISH) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                flowSpeed = 3.0f;
            } else {
                flowSpeed = 5.4f;
            }
        } else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                flowSpeed = 5.0f;
            } else {
                flowSpeed = 9.0f;
            }
        }
        

        CGPoint tempPos = player.position;
        if (tempPos.x != winSize.width*0.333f) {
            tempPos.x = winSize.width*0.333f;
        }
        player.position = tempPos;
    }
   
}

@end
