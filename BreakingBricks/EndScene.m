//
//  EndScene.m
//  BreakingBricks
//
//  Created by Iyad Horani on 14/07/2014.
//  Copyright (c) 2014 IRONIC3D. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"

@implementation EndScene

-(instancetype)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        SKAction *play = [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
        [self runAction:play];
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"You Lose!";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        tryAgain.text = @"tap to play again";
        tryAgain.fontColor = [SKColor whiteColor];
        tryAgain.fontSize = 24;
        tryAgain.position = CGPointMake(size.width / 2, -50);
        
        SKAction *moveLabel = [SKAction moveToY:(size.height / 2 - 40) duration:2.0];
        [tryAgain runAction:moveLabel];
        
        [self addChild:tryAgain];
        
    }
    
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    MyScene *start = [MyScene sceneWithSize:self.size];
    [self.view presentScene:start transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
}

@end
