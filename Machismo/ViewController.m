//
//  ViewController.m
//  Machismo
//
//  Created by Armour on 15/2/12.
//  Copyright (c) 2015年 ZJU. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end


@implementation ViewController

- (void)viewDidLoad {
    self.game.mode = 2;
    self.game.openedNumber = 0;
}

- (CardMatchingGame *) game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)deck {
    if (!_deck)_deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flip: %d", self.flipCount];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.segmentControl setEnabled:false];
    [self.game chooseCardAtIndex:cardIndex];
    self.informationLabel.text = self.game.information;
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroudImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.flipCount++;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (NSString *) titleForCard:(Card *)card {
    return card.isChosen? card.contents: @"";
}

- (UIImage *) backgroudImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen? @"card_front": @"card_back"];
}

- (IBAction)RestartButtonOnClicked:(UIButton *)sender {
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Restart!?" message:@"Are you sure you want to restart?" delegate:self cancelButtonTitle:@"No.." otherButtonTitles:@"Yes!", nil];
    [warning show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes!"]) {
        self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[self createDeck]];
        self.flipCount = -1;
        self.game.mode = 2;
        self.segmentControl.selectedSegmentIndex = 0;
        self.game.openedNumber = 0;
        [self.segmentControl setEnabled:true];
        [self updateUI];
    }
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            self.game.mode = 2;
            break;
        case 1:
            self.game.mode = 3;
            break;
        default:
            break;
    }
    UIAlertView *feedback = [[UIAlertView alloc] initWithTitle:@"Game Mode Changed!" message:[[NSString alloc] initWithFormat:@"You now have to match %lu cards", self.game.mode] delegate:nil cancelButtonTitle:@"OK, I know it~" otherButtonTitles:nil];
    [feedback show];
}

@end
