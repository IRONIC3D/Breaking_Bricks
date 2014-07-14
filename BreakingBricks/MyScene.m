//
//  MyScene.m
//  BreakingBricks
//
//  Created by Iyad Horani on 13/07/2014.
//  Copyright (c) 2014 IRONIC3D. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;

@end

@implementation MyScene

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
	
	[self addChild:self.paddle];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
		
		// Add a physics body to the scene
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
		
		// change gravity settings of the physics world
		self.physicsWorld.gravity = CGVectorMake(0, -0.2);
		
        [self addBall:size];
        [self addPlayer:size];
        [self addBricks:size];
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
