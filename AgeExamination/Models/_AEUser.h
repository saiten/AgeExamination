// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AEUser.h instead.

#import <CoreData/CoreData.h>


extern const struct AEUserAttributes {
	__unsafe_unretained NSString *birthday;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *prefecture;
} AEUserAttributes;

extern const struct AEUserRelationships {
	__unsafe_unretained NSString *results;
} AEUserRelationships;

extern const struct AEUserFetchedProperties {
} AEUserFetchedProperties;

@class AEResult;





@interface AEUserID : NSManagedObjectID {}
@end

@interface _AEUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AEUserID*)objectID;





@property (nonatomic, strong) NSDate* birthday;



//- (BOOL)validateBirthday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* prefecture;



//- (BOOL)validatePrefecture:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *results;

- (NSMutableSet*)resultsSet;





@end

@interface _AEUser (CoreDataGeneratedAccessors)

- (void)addResults:(NSSet*)value_;
- (void)removeResults:(NSSet*)value_;
- (void)addResultsObject:(AEResult*)value_;
- (void)removeResultsObject:(AEResult*)value_;

@end

@interface _AEUser (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthday;
- (void)setPrimitiveBirthday:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePrefecture;
- (void)setPrimitivePrefecture:(NSString*)value;





- (NSMutableSet*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet*)value;


@end
