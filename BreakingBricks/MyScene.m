//
//  MyScene.m
//  BreakingBricks
//
//  Created by Iyad Horani on 13/07/2014.
//  Copyright (c) 2014 IRONIC3D. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
		
		// Add a physics body to the scene
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
		
		// change gravity settings of the physics world
		self.physicsWorld.gravity = CGVectorMake(0, 0);
		
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
		CGVector ballKick = CGVectorMake(20, 20);
		// apply the vector
		[ball.physicsBody applyImpulse:ballKick];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
