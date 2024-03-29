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
@property (nonatomic) BOOL currentNumberHasDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;

- (IBAction)enterPressed;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize status = _status;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize currentNumberHasDecimal = _currentNumberHasDecimal;
@synthesize brain = _brain;

// Override setter for brain to lazily instatiate. Always ensures that _brain is not nil
- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];      
    }

    return _brain;
}

//  Somehow use this eventually?
//- (BOOL)hasDecimalPoint:(NSString *)currentScreen {
//    BOOL hasDecimal = YES;
//    NSRange positionOfDecimal = [currentScreen rangeOfString:@"."];
//
//    if (positionOfDecimal.location == NSNotFound) {
//        hasDecimal = YES;
//    }
//    
//    return hasDecimal;
//}

-(void)printDigitToCalculatorLog:(NSString *)currentAction {
    self.status.text = [self.status.text stringByAppendingString:currentAction];
}

-(void)printOperandToCalculatorLog:(NSString *)currentAction {
    NSString *spacer = @" ";
    currentAction = [currentAction stringByAppendingString:spacer];
    self.status.text = [self.status.text stringByAppendingString:currentAction];
}

- (void)presentDigitOnScreen:(NSString *)digit {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    [self printDigitToCalculatorLog:digit];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit  = sender.currentTitle;
        //NSLog(@"digit pressed = %@", digit);
        //UILabel *myDisplay = self.display; //[self display];
        //NSString *currentText = self.display.text; //[myDisplay text];
        //NSString *newText = [self.display.text stringByAppendingString:digit];
    
    NSRange positionOfDecimal = [self.display.text rangeOfString:@"."];
    if (positionOfDecimal.location == NSNotFound) {
        // No decimal in current display
        [self presentDigitOnScreen:digit];
    } else {
        // Decimal in current display
        if (![digit isEqualToString:@"."]) {
            [self presentDigitOnScreen:digit];
        }
    }

}

- (IBAction)clearDisplay {
    self.status.text = @"";
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    // If user triggers an operation before hitting Enter, fire it for them.
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    // Send current title to perform the requested operation and return the result as a double.
    double result = [self.brain performOperation:sender.currentTitle];

    // If CE (Clear Everything) is pressed trigger clearDisplay, else log the current action in the status label.
    if ([sender.currentTitle isEqualToString:@"CE"]) {
        [self clearDisplay];
    } else {
        [self printOperandToCalculatorLog:sender.currentTitle];        
    }
    
    // Wraps double result in a string and print it out in the display
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;  
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.status.text = [self.status.text stringByAppendingString:(@" ")];
}

@end
