//
//  GameScene.h
//  ChickenGame
//
//  Created by Neeraj Solanki on 24/04/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;

@end
