//
//  MyScene.m
//  BreakingBricks
//
//  Created by Iyad Horani on 13/07/2014.
//  Copyright (c) 2014 IRONIC3D. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"

@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;

@end

static const uint32_t ballCategory          = 0x1;      // 1    or 00000000000000000000000000000001
static const uint32_t brickCategory         = 0x1 << 1; // 2    or 00000000000000000000000000000010
static const uint32_t paddleCategory        = 0x1 << 2; // 4    or 00000000000000000000000000000100
static const uint32_t edgeCategory          = 0x1 << 3; // 8    or 00000000000000000000000000001000
static const uint32_t bottomEdgeCategory    = 0x1 << 4; // 16   or 00000000000000000000000000010000

@implementation MyScene {
    SKAction *playBlip;
    SKAction *playBrickHit;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
//    if (contact.bodyA.categoryBitMask == brickCategory) {
//        [contact.bodyA.node removeFromParent];
//    }
    
    // create placeholder reference for the "non ball" object
    SKPhysicsBody *notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    
    if(notTheBall.categoryBitMask == brickCategory) {
        [self runAction:playBrickHit];
        [notTheBall.node removeFromParent];
    }
    
    if (notTheBall.categoryBitMask == paddleCategory) {
        
        [self runAction:playBlip];
    }
    
    if (notTheBall.categoryBitMask == bottomEdgeCategory) {
        EndScene *end = [EndScene sceneWithSize:self.size];
        [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }
}

- (void)addBottomEdge:(CGSize)size {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
}

- (void)addBall:(CGSize)size {
    // Create a new sprite node from an image
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    // Position the ball midway through the screen
    CGPoint myPoint = CGPointMake(size.width / 2, size.height / 2);
    ball.position = myPoint;
	
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width / 2];
    ball.physicsBody.friction = 0;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
	
    // Add the sprite node to the scene
    [self addChild:ball];

    // create the vector
    CGVector ballKick = CGVectorMake(12, 12);
    // apply the vector
    [ball.physicsBody applyImpulse:ballKick];
}

- (void)addBricks:(CGSize)size {
    for (int i = 0; i < 4; i++) {
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        // add a static physics body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        brick.physicsBody.categoryBitMask = brickCategory;
        
        int xPos = size.width / 5 * (i+1);
        int yPos = size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        [self addChild:brick];
    }
}

- (void)addPlayer:(CGSize)size {
	// Create paddle sprite
	self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
	self.paddle.position = CGPointMake(size.width / 2, 100);
	self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
	self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
	
	[self addChild:self.paddle];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
        playBlip = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        playBrickHit = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
        
        // Add a physics body to the scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
		
        // change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, -0.2);
        self.physicsWorld.contactDelegate = self;
        
        [self addBall:size];
        [self addPlayer:size];
        [self addBricks:size];
        [self addBottomEdge:size];
    }
    return self;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		CGPoint location = [touch locationInNode:self];
		CGPoint newPosition = CGPointMake(location.x, 100);
		
		// stop the paddle from going too far
		if (newPosition.x < self.paddle.size.width / 2) {
			newPosition.x = self.paddle.size.width / 2;
		}
		if(newPosition.x > (self.size.width - self.paddle.size.width / 2)) {
			newPosition.x = (self.size.width - self.paddle.size.width / 2);
		}
		
		self.paddle.position = newPosition;
	}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
