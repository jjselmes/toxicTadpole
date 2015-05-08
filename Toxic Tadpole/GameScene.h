//
//  GameScene.h
//  Boing!
//

//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define CONTENT_COUNT_LIMIT 140

static const uint32_t floorCategory = 0x1<<1;             // ship
static const uint32_t playerCategory = 0x1<<2;      // charge changer walls
static const uint32_t blockCategory = 0x1<<3;      // charge changer walls
static const uint32_t sceneCategory = 0x1<<4;
static const uint32_t reverseCategory = 0x1<<5;


@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property CGSize winSize;
@property SKSpriteNode *player;

@property (nonatomic, strong) SKSpriteNode *floor;
@property (nonatomic, strong) SKSpriteNode *floor2;
@property (nonatomic, strong) SKSpriteNode *roof;
@property (nonatomic, strong) SKSpriteNode *roof2;
@property NSDate *start;
@property NSDate *now;
@property float flowSpeed;
@property BOOL middleHit;
@property (nonatomic, strong) NSMutableArray *previousContent;
@property BOOL floorHit;
@property BOOL touching;
@property (nonatomic, strong) SKShapeNode *trajectory;
@property CGFloat originalY;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSMutableArray *doneBlocks;
@property (nonatomic, assign) BOOL inAir;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL touchEnded;
@property (nonatomic, assign) int contentCounter;
@property (nonatomic, assign) CGSize originalPlayerSize;
@property (nonatomic, assign) int reverseCounter;

@property (nonatomic, assign) BOOL isDead;

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *background2;

@property (nonatomic, strong) SKSpriteNode *midground;
@property (nonatomic, strong) SKSpriteNode *midground2;

@property (nonatomic, strong) SKSpriteNode *foreground;
@property (nonatomic, strong) SKSpriteNode *foreground2;

@property (nonatomic, strong) NSMutableArray *liveContent;

-(id)initWithSize:(CGSize)size;
+(id)sceneWithSize:(CGSize)size;

@end
