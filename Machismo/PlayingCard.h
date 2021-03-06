//
//  PlayingCard.h
//  Machismo
//
//  Created by Armour on 15/2/14.
//  Copyright (c) 2015年 ZJU. All rights reserved.
//

#ifndef Machismo_PlayingCard_h
#define Machismo_PlayingCard_h

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;

@end

#endif
