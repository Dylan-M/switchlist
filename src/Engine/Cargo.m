// 
//  Cargo.m
//  SwitchList
//
//  Created by Robert Bowdidge on 6/9/06.
//
// Copyright (c)2006 Robert Bowdidge,
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE.

#import "Cargo.h"

#import "CarType.h"
#import "Industry.h"

@implementation Cargo 


@dynamic priority;
@dynamic carTypeRel;
@dynamic cargoDescription;
@dynamic source,destination;
@dynamic rate, rateUnits, unloadingDays;

- (struct CargoRate) cargoRate {
    struct CargoRate retValue;
    [self willAccessValueForKey: @"rate"];
    [self willAccessValueForKey: @"rateUnits"];
  	NSNumber *rateUnits = [self valueForKeyPath: @"rateUnits"];
	NSNumber *rate = [self valueForKeyPath: @"rate"];
	retValue.rate = [rate intValue];
	retValue.units = [rateUnits intValue];
	[self didAccessValueForKey: @"rate"];
   	[self didAccessValueForKey: @"rateUnits"];
    return retValue;
}

// Returns the integer number of cars per week expected to move carrying this
// cargo.
// TODO(bowdidge): Change all the algorithms to correctly handle a small number of
// cars per month.  One possibility is to do all the analysis in carsPerMonth.
// Also switch the new suggested cargo assistant to allow units.
- (NSNumber *)carsPerWeek {
	[self willAccessValueForKey: @"rate"];
   	[self willAccessValueForKey: @"rateUnits"];
	NSNumber *rateUnits = [self valueForKeyPath: @"rateUnits"];
	NSNumber *rate = [self valueForKeyPath: @"rate"];
	int rateValue = [rate intValue];
	int rateUnitsEnum = [rateUnits intValue];
	float carsPerWeek = 0;
	switch (rateUnitsEnum) {
		case RATE_PER_DAY:
			carsPerWeek = rateValue * 7;
			break;
		case RATE_PER_WEEK:
			carsPerWeek = rateValue;
			break;
		case RATE_PER_MONTH:
			carsPerWeek = rateValue / 4.0;
			break;
	}
    [self didAccessValueForKey: @"rate"];
    [self didAccessValueForKey: @"rateUnits"];
	return [NSNumber numberWithInt: carsPerWeek];
}

- (NSNumber*) carsPerMonth {
	[self willAccessValueForKey: @"rate"];
   	[self willAccessValueForKey: @"rateUnits"];
	NSNumber *rateUnits = [self valueForKeyPath: @"rateUnits"];
	NSNumber *rate = [self valueForKeyPath: @"rate"];
	int rateValue = [rate intValue];
	int rateUnitsEnum = [rateUnits intValue];
	float carsPerMonth = 0;
	switch (rateUnitsEnum) {
		case RATE_PER_DAY:
			carsPerMonth = rateValue * 30.0;
			break;
		case RATE_PER_WEEK:
			carsPerMonth = rateValue * 30.0 / 7.0;
			break;
		case RATE_PER_MONTH:
			carsPerMonth = rateValue;
			break;
	}
    [self didAccessValueForKey: @"rate"];
    [self didAccessValueForKey: @"rateUnits"];
	return [NSNumber numberWithInt: carsPerMonth];
}

// Sets the preferred number of cars carrying this cargo to move each week.
- (void)setCarsPerWeek:(NSNumber *)value {
    [self willChangeValueForKey: @"rate"];
    [self willChangeValueForKey: @"rateUnits"];
    [self setPrimitiveValue: value forKey: @"rate"];
	[self setPrimitiveValue: [NSNumber numberWithInt: RATE_PER_WEEK] forKey: @"rateUnits"];
    [self didChangeValueForKey: @"rate"];
    [self didChangeValueForKey: @"rateUnits"];
}


// Sets the preferred number of cars carrying this cargo to move each week.
- (void)setCarsPerMonth:(NSNumber *)value {
    [self willChangeValueForKey: @"rate"];
    [self willChangeValueForKey: @"rateUnits"];
    [self setPrimitiveValue: value forKey: @"rate"];
	[self setPrimitiveValue: [NSNumber numberWithInt: RATE_PER_MONTH] forKey: @"rateUnits"];
    [self didChangeValueForKey: @"rate"];
    [self didChangeValueForKey: @"rateUnits"];
}

- (BOOL) isSourceOffline {
	return ([[self valueForKeyPath: @"source"] isOffline]);
}

- (BOOL) isPriority {
    return [[self priority] intValue] != 0;
}
- (BOOL) isDestinationOffline {
	return ([[self valueForKeyPath: @"destination"] isOffline]);
}

// Only for consistency in template language.
- (NSString*) name {
	return [self cargoDescription];
}

// Returns the string name of the car type for the cargo.
- (NSString*) carType {
	return [[self carTypeRel] carTypeName];
}

// Returns the text that should appear when hovering over the cargo in a menu.
- (NSString*) tooltip {
	NSString *carTypeLabel = @"undefined";
	if (![self carTypeRel]) {
		carTypeLabel = @"";
	} else if (![[self carTypeRel] carTypeDescription] ||
			   [[[self carTypeRel] carTypeDescription] length] == 0) {
		carTypeLabel = [NSString stringWithFormat: @"'%@' ", [self carType]];
	}else {
		carTypeLabel= [NSString stringWithFormat: @"'%@' (%@) ",
					      [self carType], [[self carTypeRel] carTypeDescription]];
	}

	NSString *destinationString;
	if ([self destination]) {
		destinationString = [[self destination] name];
	} else {
		destinationString = @"No Value";
	}
	
	NSString *sourceString;
	if ([self source]) {
		sourceString = [[self source] name];
	} else {
		sourceString = @"No Value";
	}
	
	return [NSString stringWithFormat: @"%@, sent from %@ to %@, %d %@cars per week",
			[self cargoDescription], sourceString, destinationString,
			[[self carsPerWeek] intValue], carTypeLabel];
}

- (NSString*) destinationString {
   	if ([self destination]) {
        return [[self destination] name];
    }
    return @"unset";
}

- (NSString*) sourceString {
   	if ([self source]) {
        return [[self source] name];
    }
    return @"unset";
}

- (NSString*) description {
    NSString *carTypeLabel = @"";
    if (self.carType) {
        carTypeLabel = [NSString stringWithFormat: @"%@ (%@) ", [self carType], [[self carTypeRel] carTypeDescription]];
    }
    
	return [NSString stringWithFormat: @"%@, sent from %@ to %@, %d %@cars per week",
			[self cargoDescription], [self sourceString], [self destinationString],
			[[self carsPerWeek] intValue], carTypeLabel];
}

- (NSString*) descriptionForCopy {
    return [NSString stringWithFormat: @"%@\t%@\t%@\n", [self name], [self sourceString], [self destinationString]];
}

@end
