// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AEUser.m instead.

#import "_AEUser.h"

const struct AEUserAttributes AEUserAttributes = {
	.birthday = @"birthday",
	.name = @"name",
	.prefecture = @"prefecture",
};

const struct AEUserRelationships AEUserRelationships = {
	.results = @"results",
};

const struct AEUserFetchedProperties AEUserFetchedProperties = {
};

@implementation AEUserID
@end

@implementation _AEUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (AEUserID*)objectID {
	return (AEUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic birthday;






@dynamic name;






@dynamic prefecture;






@dynamic results;

	
- (NSMutableSet*)resultsSet {
	[self willAccessValueForKey:@"results"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"results"];
  
	[self didAccessValueForKey:@"results"];
	return result;
}
	






@end
