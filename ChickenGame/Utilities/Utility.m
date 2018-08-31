//
//  Utility.m
//  ChickenGame
//
//  Created by Neeraj Solanki on 01/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSArray*)actionsArray:(CGFloat)waitDuration fade:(CGFloat)fadeDuration
{
    return @[
             [SKAction waitForDuration:waitDuration],
             [SKAction fadeOutWithDuration:fadeDuration],
             [SKAction removeFromParent],
             ];
}

@end
