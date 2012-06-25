//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Thomas Klun on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

//  Overrides setter to ensure that it is never nil
- (NSMutableArray *)operandStack {
    // Lazy instantiation
    if (_operandStack == nil) {
        _operandStack = [[NSMutableArray alloc] init];   
    }
    return _operandStack;
}

//  pushOperand takes a double and adds it to the operandStack as an double formatted as a number
- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

//  Finds the last item in the operandStack mutable array and sets it to operandObject. Removes last value from the array, if there is a value in the array.
- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

//  Does string comparisons (in two ways) in order to determine which operation to proceed with.

- (double)performOperation:(NSString *)operation {
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([@"/" isEqualToString:operation]) {
        result = [self popOperand] / [self popOperand];
    } else if ([@"-" isEqualToString:operation]) {
        result = [self popOperand] - [self popOperand];
    } else if ([@"sin" isEqualToString:operation]) {
        result = sin([self popOperand]);
    } else if ([@"cos" isEqualToString:operation]) {
        result = cos([self popOperand]);
    } else if ([@"sqrt" isEqualToString:operation]) {
        result = sqrt([self popOperand]);
    } else if ([@"π" isEqualToString:operation]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    return result;
}

@end
