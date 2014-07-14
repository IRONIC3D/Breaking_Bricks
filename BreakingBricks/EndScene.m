//
//  EndScene.m
//  BreakingBricks
//
//  Created by Iyad Horani on 14/07/2014.
//  Copyright (c) 2014 IRONIC3D. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

-(instancetype)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"You Lose!";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
    }
    
    return self;
}

@end
