// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AEResult.m instead.

#import "_AEResult.h"

const struct AEResultAttributes AEResultAttributes = {
	.balanceScore = @"balanceScore",
	.bodyAge = @"bodyAge",
	.brainAge = @"brainAge",
	.calculateScore = @"calculateScore",
	.date = @"date",
};

const struct AEResultRelationships AEResultRelationships = {
	.user = @"user",
};

const struct AEResultFetchedProperties AEResultFetchedProperties = {
};

@implementation AEResultID
@end

@implementation _AEResult

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Result";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Result" inManagedObjectContext:moc_];
}

- (AEResultID*)objectID {
	return (AEResultID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"balanceScoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"balanceScore"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"bodyAgeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bodyAge"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"brainAgeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"brainAge"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"calculateScoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"calculateScore"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic balanceScore;



- (int16_t)balanceScoreValue {
	NSNumber *result = [self balanceScore];
	return [result shortValue];
}

- (void)setBalanceScoreValue:(int16_t)value_ {
	[self setBalanceScore:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBalanceScoreValue {
	NSNumber *result = [self primitiveBalanceScore];
	return [result shortValue];
}

- (void)setPrimitiveBalanceScoreValue:(int16_t)value_ {
	[self setPrimitiveBalanceScore:[NSNumber numberWithShort:value_]];
}





@dynamic bodyAge;



- (int16_t)bodyAgeValue {
	NSNumber *result = [self bodyAge];
	return [result shortValue];
}

- (void)setBodyAgeValue:(int16_t)value_ {
	[self setBodyAge:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBodyAgeValue {
	NSNumber *result = [self primitiveBodyAge];
	return [result shortValue];
}

- (void)setPrimitiveBodyAgeValue:(int16_t)value_ {
	[self setPrimitiveBodyAge:[NSNumber numberWithShort:value_]];
}





@dynamic brainAge;



- (int16_t)brainAgeValue {
	NSNumber *result = [self brainAge];
	return [result shortValue];
}

- (void)setBrainAgeValue:(int16_t)value_ {
	[self setBrainAge:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBrainAgeValue {
	NSNumber *result = [self primitiveBrainAge];
	return [result shortValue];
}

- (void)setPrimitiveBrainAgeValue:(int16_t)value_ {
	[self setPrimitiveBrainAge:[NSNumber numberWithShort:value_]];
}





@dynamic calculateScore;



- (int16_t)calculateScoreValue {
	NSNumber *result = [self calculateScore];
	return [result shortValue];
}

- (void)setCalculateScoreValue:(int16_t)value_ {
	[self setCalculateScore:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCalculateScoreValue {
	NSNumber *result = [self primitiveCalculateScore];
	return [result shortValue];
}

- (void)setPrimitiveCalculateScoreValue:(int16_t)value_ {
	[self setPrimitiveCalculateScore:[NSNumber numberWithShort:value_]];
}





@dynamic date;






@dynamic user;

	






@end
