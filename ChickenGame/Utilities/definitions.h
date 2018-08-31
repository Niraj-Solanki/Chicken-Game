//
//  definitions.h
//  ChickenGame
//
//  Created by Neeraj Solanki on 01/05/17.
//  Copyright © 2017 Neeraj Solanki. All rights reserved.
//

#ifndef definitions_h
#define definitions_h

#define LINE_CATEGORY 0
#define EGG_CATEGORY 1

// GameScene.sks Object Names
#define SCORE_LABEL @"score"
#define LIFE_LEFT @"lifeLeft"
#define EGG_LEFT @"eggLeft"
#define BUCKET_RIGHT @"bucketRight"
#define BOTTOM_BORDER @"bottomBorder"
#define RESTART @"Restart"
#define QUIT @"Quit"
#define PAUSE_PLAY @"pausePlay"
#define BUCKET_BODY @"bucketBody"

#define BACKGROUND_SCENE @"backgroundScene"
#define GOLDEN_EGG @"goldenEgg"
#define GREEN_EGG @"greenEgg"
#define COLORFUL_EGG @"colorfulEgg"
#define EVIL_EGG @"evilEgg"
#define LIFE_EGG @"lifeEgg"
#define GAME_SCENE @"GameScene"
#define CONFIRMATION @"Confirmation"

#define QUIT_GAME_MESSAGE @"Do You Want To Quit Game Click Quit!  Click Resume To Play Continue Game !"
#define PLAY_AGAIN_MESSAGE @"Game Over ! Tap To Play Again !"

#define GAME_RESUME_TEXT @"Tap To Resume game !"
#define GAME_OVER_LABEL @"gameOverLabel"
#define RESUME @"Resume"


#define LIFE @"life"
#define EVIL @"evil"
#define BOMB @"bomb"
#define PLAY @"play"
#define PAUSE @"pause"
#define BOMB_IMAGE @"bomb"
#define EVIL_IMAGE @"evil"
#define COIN_IMAGE @"coin"
#define BROKEN_EGG @"brokenEgg"

#define NEW_EGG_IMAGE_SIZE 60
#define NEW_EGG_ACTION_WAIT_DURATION 15
#define NODE_OBJECT_WAIT_DURATION 0.5
#define NODE_OBJECT_FADE_DURATION 0.5
#define EGG_INCREMENT 15
#define LABEL_FONT_SIZE 60;
typedef enum
{
    greenEgg =2,
    goldenEgg =1,
    colorfulEgg =5,
}EggType;


#endif /* definitions_h */
