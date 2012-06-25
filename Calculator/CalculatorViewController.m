//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Thomas Klun on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

// Override setter for brain to lazily instatiate. Always ensures that _brain is not nil
- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];   
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit  = sender.currentTitle;
        //NSLog(@"digit pressed = %@", digit);
        //UILabel *myDisplay = self.display; //[self display];
        //NSString *currentText = self.display.text; //[myDisplay text];
        //NSString *newText = [self.display.text stringByAppendingString:digit];    
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

@end
