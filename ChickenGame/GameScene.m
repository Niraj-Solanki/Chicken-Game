//
//  GameScene.m
//  SpriteKitDemo
//
//  Created by Neeraj Solanki on 19/04/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#import "GameScene.h"
#import "common.h"
@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    
    SKSpriteNode *bucketRight;
    SKSpriteNode *bucketBody;
    SKSpriteNode *bottomBorder;
    
    SKLabelNode *eggLeftLabel;
    SKLabelNode *scoreLabel;
    SKLabelNode *lifeLeftLabel;
    SKLabelNode *resumeGameLabel;
    SKLabelNode *gameOverLabel;
    
    CGMutablePathRef pathToDraw;
    
    SKShapeNode *yourline;
    
    
    
    CGFloat waitDuratonFallingEgg;
    CGFloat levelGravity;
    
    NSInteger score;
    NSInteger currentLevel;
    NSInteger eggLeft;
    NSInteger eggLimit;
    NSInteger lifeLeft;
    NSInteger gameResumeCountDown;
    
    
    BOOL isGamePaused;
    BOOL isGameOver;
    BOOL isBucketHold;
    BOOL initiated;
    
    NSMutableArray *highScores;
    NSMutableArray <SKShapeNode*> *lineNodes;
    
    NSUserDefaults *gameScoreRecord;
}



- (void)sceneDidLoad {
    // Setup your scene here
    if (initiated)
    {
        return;
    }
    initiated = YES;
    
    gameScoreRecord =[NSUserDefaults standardUserDefaults];
    
    waitDuratonFallingEgg=1.0f;
    levelGravity=(0-1.0f);
    
    eggLeft=25;
    currentLevel=1;
    eggLimit=25;
    score=0;
    gameResumeCountDown =3;
    lifeLeft=3;
    _lastUpdateTime = 0;
    
    isGamePaused=NO;
    isGameOver=NO;
    isBucketHold=NO;
    
    [self scenePhysicsBody];
    [self rightBucketBody];
    [self bucketBody];
    [self scoreBoardInitilize];
    [self getHighestScoreBoard];
    [self timerEggGenerator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:@"gameStatusCheck"
                                               object:nil];
}

//==========================Methods======================================//
#pragma mark Methods

-(SKLabelNode*)getLabelNodeWithName:(NSString*)nodeName
{
    return (SKLabelNode*)[self childNodeWithName:nodeName];
}

-(SKSpriteNode*)getSpriteNodeWithName:(NSString*)nodeName
{
    return (SKSpriteNode*)[self childNodeWithName:nodeName];
}

-(SKShapeNode*)getShapeNodeWithName:(NSString*)nodeName
{
    return (SKShapeNode*)[self childNodeWithName:nodeName];
}

-(SKTexture*)textureWithName:(NSString*)name
{
    return (SKTexture*)[SKTexture textureWithImageNamed:name];
}


//===========================Score Board=======================================//
#pragma mark Score Board

-(void)scoreBoardInitilize
{
    scoreLabel = [self getLabelNodeWithName:SCORE_LABEL];
    lifeLeftLabel = [self getLabelNodeWithName:LIFE_LEFT];
    eggLeftLabel = [self getLabelNodeWithName:EGG_LEFT];
    
    resumeGameLabel = [SKLabelNode new];
    resumeGameLabel.zPosition=1;
    resumeGameLabel.text=GAME_RESUME_TEXT;
    resumeGameLabel.name=RESUME;
    resumeGameLabel.color=[SKColor blackColor];
    resumeGameLabel.fontSize =  LABEL_FONT_SIZE;
    resumeGameLabel.position=CGPointZero;
}


//===================== SCENE PHYSICS BODY =========================//
#pragma mark Physics World

-(void)scenePhysicsBody
{
    
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:BACKGROUND_SCENE];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -1;
    
    [self addChild:background];
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, -1.0f);
    
}


//===================== RIGHT BUCKET ========================//
#pragma mark RightBucket

-(void)rightBucketBody
{
    
    bucketRight=[self getSpriteNodeWithName:BUCKET_RIGHT];
    bucketRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bucketRight.size];
    bucketRight.physicsBody.usesPreciseCollisionDetection = YES;
    bucketRight.physicsBody.dynamic=NO;
    
}



//===================== Highest Score Board ================//
#pragma mark Highest Score
-(void)getHighestScoreBoard
{
    if (gameScoreRecord == nil)
    {
        highScores = [NSMutableArray new];
        [gameScoreRecord setObject:highScores forKey:@"highScores"];
        [gameScoreRecord synchronize];
    }
    else
    {
        highScores =[NSMutableArray new];
        highScores = [[gameScoreRecord objectForKey:@"highScores"] mutableCopy];
        
        if(highScores == nil)
        {
            highScores =[NSMutableArray new];
        }
    }
}

-(void)updateHighestScoreBoard
{
    
    [highScores insertObject:[NSNumber numberWithInteger:(score)] atIndex:0];
    
    for(int i=0;i<highScores.count;i++)
    {
        for(int j=i;j<highScores.count;j++)
        {
            if([[highScores objectAtIndex:i] intValue] <[[highScores objectAtIndex:j] intValue])
            {
                NSNumber *tempScore=[highScores objectAtIndex:i];
                [highScores replaceObjectAtIndex:i withObject:[highScores objectAtIndex:j]];
                [highScores replaceObjectAtIndex:j withObject:tempScore];
            }
        }
    }
    
    if(highScores.count>5)
    {
        [highScores removeLastObject];
    }
    
    [gameScoreRecord setObject:highScores forKey:@"highScores"];
    [gameScoreRecord synchronize];
}




//===================== Bucket Body ========================//
#pragma mark  Bucket Body

-(void)bucketBody
{
    bucketBody=[self getSpriteNodeWithName:BUCKET_BODY];
    bucketBody.physicsBody.dynamic=NO;
}

//================== EGG GENERATOR ==========================//
#pragma mark Egg Generator

-(void)timerEggGenerator
{
    NSArray *eggTypes = [NSArray arrayWithObjects:GOLDEN_EGG,GREEN_EGG,EVIL_EGG,COLORFUL_EGG,EVIL_EGG,GOLDEN_EGG,GOLDEN_EGG,BOMB, nil];
    
    id wait = [SKAction waitForDuration:waitDuratonFallingEgg];
    id run = [SKAction runBlock:^{
        
        // Comment- Generate Life Egg When Egg Limit Left Half And Current Level > 2
        if((2<currentLevel) &&(eggLeft==eggLimit/2))
        {
            
            [self randomEggNodesWithType:LIFE_EGG];
            eggLeft--;
            eggLeftLabel.text=[NSString stringWithFormat:@"X %d",(int)eggLeft];
            
        }
        else //-Comment Generate Any Of Egg From Array EggTypes
        {
            
            [self randomEggNodesWithType:[eggTypes objectAtIndex:arc4random()%8]];
            eggLeft--;
            eggLeftLabel.text=[NSString stringWithFormat:@"X %d",(int)eggLeft];
            
        }
    }];
    
    
    SKAction *sequence = [SKAction sequence:@[wait, run]];
    SKAction *repeat = [SKAction repeatAction:sequence count:eggLimit];
    [self runAction:repeat];
    
}

-(void)randomEggNodesWithType:(NSString *)type
{
    
    // Comment- Egg Generating Position. Hens Positions
    CGFloat eggPositions[] = {-325, -195, -65, 65, 195.0,325.0};
    
    CGFloat newEggXPosition = eggPositions[arc4random()%6];
    CGFloat newEggYPosition = 440;
    
    SKSpriteNode *newEgg = [MySpriteNode initWithImageTexture:type];
    newEgg.position =CGPointMake(newEggXPosition, newEggYPosition);
    
    [self addChild : newEgg];
}

//===================== Game Reset ==========================//
#pragma mark Game Reset

-(void)gameReset
{
    [self updateHighestScoreBoard];
    GKScene *scene = [GKScene sceneWithFileNamed:GAME_SCENE];
    GameScene *sceneNode = (GameScene *)scene.rootNode;
    sceneNode.entities = [scene.entities mutableCopy];
    sceneNode.graphs = [scene.graphs mutableCopy];
    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:sceneNode];
}

// =================== Quit Game ==========================//
#pragma mark Quit Game
-(void)quitGame
{
    self.paused=YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:CONFIRMATION message:QUIT_GAME_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *quit = [UIAlertAction actionWithTitle:QUIT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self updateHighestScoreBoard];
        UINavigationController *vc = (UINavigationController *)self.view.window.rootViewController;
        [vc popToRootViewControllerAnimated:YES];
    }];
    
    UIAlertAction *resume = [UIAlertAction actionWithTitle:RESUME style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 if(!isGameOver)
                                 {
                                     if(isGamePaused)
                                     {
                                         self.paused=YES;
                                     }
                                     else
                                     {
                                         self.paused=NO;
                                     }
                                 }
                             }];
    
    [alert addAction:resume];
    [alert addAction:quit];
    [self.view.window.rootViewController presentViewController:alert
                                                      animated:YES
                                                    completion:nil];
}



//===================== Game Over ==========================//
#pragma mark Game Over

-(void)gameOver
{
    isGameOver=YES;
    gameOverLabel=[SKLabelNode new];
    gameOverLabel.text=[NSString stringWithFormat:PLAY_AGAIN_MESSAGE];
    gameOverLabel.name=GAME_OVER_LABEL;
    gameOverLabel.color=[UIColor darkTextColor];
    gameOverLabel.fontSize =  LABEL_FONT_SIZE;
    gameOverLabel.position=CGPointZero;
    
    [self addChild:gameOverLabel];
    [self updateHighestScoreBoard];
    self.paused =YES;
    
}



//===================== Game Pause & Play ==========================//
#pragma mark Game Pause & Resume
-(void)gamePausePlay:(NSString *)status
{
    SKSpriteNode *spriteNode = [self getSpriteNodeWithName:PAUSE_PLAY];
    spriteNode.texture=[self textureWithName:status];
    if(self.paused)
    {
        self.paused = isGamePaused = NO;
        [resumeGameLabel removeFromParent];
    }
    else
    {
        self.paused = isGamePaused = YES;
        [self addChild:resumeGameLabel];
    }
}


-(void)applicationWillEnterForeground:(NSNotification *)notification
{
    if(isGameOver)
    {
        [self gameReset];
    }
    else
    {
        if(isGamePaused)
        {
            [self gamePausePlay:PAUSE];
        }
    }
}


//==========================================================//
#pragma mark Touch Methods

- (void)touchDownAtPoint:(CGPoint)pos {
    
    
}

- (void)touchMovedToPoint:(CGPoint)pos
{
    if(isBucketHold)
    {
        CGPoint newPoints = pos;
        newPoints.y = (0-550);
        
        // Comment- Moving Bucket In Screen
        if(newPoints.x > -325 && newPoints.x < 325)
        {
            bucketBody.position = newPoints;
            newPoints.y = (0-510);
            bucketRight.position = newPoints;
        }
    }
}

- (void)touchUpAtPoint:(CGPoint)pos {
    isBucketHold=NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:positionInScene];
    
    // Comment- Restart Game Conditions
    if([node.name isEqualToString:RESTART] || [node.name isEqualToString:GAME_OVER_LABEL])
    {
        [self gameReset];
    }
    
    // Comment- Quit game Conditions
    else if([node.name isEqualToString:QUIT])
    {
        [self quitGame];
    }
    
    if(!isGameOver)
    {
        if(!isGamePaused)
        {
            if([node.name isEqualToString:BUCKET_BODY])
            {
                isBucketHold=YES;
            }
            for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
        }
        
        // Comment- Game Pause And Play Conditions
        if([node.name isEqualToString:PAUSE_PLAY] || [node.name isEqualToString:RESUME])
        {
            if(isGamePaused)
            {
                [self gamePausePlay:PAUSE];
            }
            else
            {
                [self gamePausePlay:PLAY];
            }
        }
    } // if End
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isGameOver)
    {
        for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}



// ========================================================================//
#pragma mark Begin Contact Nodes

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //Comment-  Crash Eggs When they Collide With Bottom Border Of Screen
    if(([firstBody.node.name isEqualToString:GOLDEN_EGG] || [firstBody.node.name isEqualToString:EVIL_EGG] || [firstBody.node.name isEqualToString:BOMB] ||[firstBody.node.name isEqualToString:GREEN_EGG] || [firstBody.node.name isEqualToString:COLORFUL_EGG]) && [secondBody.node.name isEqualToString:BOTTOM_BORDER])
    {
        firstBody.node.physicsBody.dynamic=NO;
        SKSpriteNode *node =(SKSpriteNode*)firstBody.node;
        if([node.name isEqualToString:EVIL_EGG] || [node.name isEqualToString:BOMB])
        {
            [self removeNode:node removingTexture:BOMB_IMAGE];
        }
        else
        {
            [self removeNode:node removingTexture:BROKEN_EGG];
        }
    }
    
    //Comment- Life Decrement When Bomb  Collide With Bucket
    else if([firstBody.node.name isEqualToString:BOMB] && [secondBody.node.name isEqualToString:BUCKET_RIGHT])
    {
        lifeLeft--;
        firstBody.node.physicsBody.dynamic=NO;
        [self removeNode:(SKSpriteNode*)firstBody.node removingTexture:EVIL];
        lifeLeftLabel.text=[NSString stringWithFormat:@"X %d",(int)lifeLeft];
        
        if(lifeLeft<1) // if user Life left 0 . GameOver
        {
            [self gameOver];
        }
    }
    
    //Comment-  Life Increment when Life Egg Collide With Bucket
    else if([firstBody.node.name isEqualToString:LIFE_EGG] && [secondBody.node.name isEqualToString:BUCKET_RIGHT])
    {
        lifeLeft++;
        firstBody.node.physicsBody.dynamic=NO;
        [self removeNode:(SKSpriteNode*)firstBody.node removingTexture:LIFE];
        lifeLeftLabel.text=[NSString stringWithFormat:@"X %d",(int)lifeLeft];
    }
    
    
    //Comment-  Score Increment According Egg Type When Eggs Collide With Bucket
    else if(([firstBody.node.name isEqualToString:GOLDEN_EGG] || [firstBody.node.name isEqualToString:GREEN_EGG] || [firstBody.node.name isEqualToString:COLORFUL_EGG]) && [secondBody.node.name isEqualToString:BUCKET_RIGHT])
    {
        
        firstBody.node.physicsBody.dynamic=NO;
        [self scoreIncrement:(SKSpriteNode *)firstBody.node];
    }
    
    // Score Decrement When Evil Egg Collide With Bucket
    else if([firstBody.node.name isEqualToString:EVIL_EGG] && [secondBody.node.name isEqualToString:BUCKET_RIGHT])
    {
        score--;
        firstBody.node.physicsBody.dynamic=NO;
        [self removeNode:(SKSpriteNode*)firstBody.node removingTexture:BROKEN_EGG];
        scoreLabel.text=[NSString stringWithFormat:@"%d",(int)score];
    }
    
}


#pragma mark Removing Node When Node Work Is Over

-(void)removeNode:(SKSpriteNode *)node removingTexture:(NSString *)name
{
    node.texture=[self textureWithName:name];
    [node runAction:[SKAction sequence:[Utility actionsArray:NODE_OBJECT_WAIT_DURATION fade:NODE_OBJECT_FADE_DURATION]]];
}



#pragma mark Score Increment

-(void)scoreIncrement:(SKSpriteNode *)egg
{
    
    SKLabelNode *earnPoint =[[SKLabelNode alloc]init];
    NSInteger points;
    if([egg.name isEqualToString:GREEN_EGG])
    {
        points =greenEgg;
    }
    else if([egg.name isEqualToString:GOLDEN_EGG])
    {
        points =goldenEgg;
    }
    else
    {
        points = colorfulEgg;
    }
    score = score +points;;
    earnPoint.text = [NSString stringWithFormat:@"+%d",(int)points];
    
    
    earnPoint.position=CGPointZero;
    earnPoint.fontSize=LABEL_FONT_SIZE;
    
    earnPoint.fontColor = [UIColor blackColor];
    [self addChild:earnPoint];
    [earnPoint runAction:[SKAction sequence:[Utility actionsArray:NODE_OBJECT_WAIT_DURATION fade:NODE_OBJECT_FADE_DURATION]]];
    
    
    [self removeNode:egg removingTexture:COIN_IMAGE];
    scoreLabel.text=[NSString stringWithFormat:@"%d",(int)score];
}


-(void)updateLevel
{
    
    currentLevel++;
    levelGravity = levelGravity + -0.5;
    waitDuratonFallingEgg = waitDuratonFallingEgg - 0.05;
    eggLimit = eggLimit + EGG_INCREMENT;
    eggLeft = eggLimit;
    
    self.physicsWorld.gravity= CGVectorMake(0.0f, levelGravity);
    SKLabelNode *gameOverlabel=[SKLabelNode new];
    gameOverlabel.text=[NSString stringWithFormat:@"Level %d",(int)currentLevel];
    gameOverlabel.color=[UIColor darkTextColor];
    gameOverlabel.fontSize =  LABEL_FONT_SIZE;
    gameOverlabel.position=CGPointZero;
    [gameOverlabel runAction:[SKAction sequence:@[
                                                  [SKAction waitForDuration:1],
                                                  [SKAction fadeOutWithDuration:1],
                                                  [SKAction removeFromParent],
                                                  [SKAction runBlock:^{[self timerEggGenerator]; }]
                                                  ]]];
    [self addChild:gameOverlabel];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendeevil
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
        
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
    
    _lastUpdateTime = currentTime;
    int countNode= (int)self.children.count;
    
    //Comment- Update Level When all nodes are removed and egg left 0
    if(countNode <= 23  && eggLeft ==0)
    {
        [self updateLevel];
    }
}




@end
