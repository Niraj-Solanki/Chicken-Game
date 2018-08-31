//
//  MySpriteKit.m
//  ChickenGame
//
//  Created by Neeraj Solanki on 03/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "MySpriteNode.h"

@implementation MySpriteNode

+(SKSpriteNode*)initWithImageTexture:(NSString *)texture
{
    
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:texture];
    node.name=texture;
    node.size = CGSizeMake(NEW_EGG_IMAGE_SIZE, NEW_EGG_IMAGE_SIZE);
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.dynamic = YES;
    node.physicsBody.contactTestBitMask = EGG_CATEGORY;
    node.physicsBody.categoryBitMask = LINE_CATEGORY;
    node.physicsBody.contactTestBitMask = YES;
    node.physicsBody.restitution=0.0001f;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    
    // Comment- Remove Egg Automatically If It Lives 15 Seconds
    [node runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:NEW_EGG_ACTION_WAIT_DURATION],
                                         [SKAction removeFromParent],
                                         ]]];
    return node;
}
@end
