// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AEResult.h instead.

#import <CoreData/CoreData.h>


extern const struct AEResultAttributes {
	__unsafe_unretained NSString *balanceScore;
	__unsafe_unretained NSString *bodyAge;
	__unsafe_unretained NSString *brainAge;
	__unsafe_unretained NSString *calculateScore;
	__unsafe_unretained NSString *date;
} AEResultAttributes;

extern const struct AEResultRelationships {
	__unsafe_unretained NSString *user;
} AEResultRelationships;

extern const struct AEResultFetchedProperties {
} AEResultFetchedProperties;

@class AEUser;







@interface AEResultID : NSManagedObjectID {}
@end

@interface _AEResult : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AEResultID*)objectID;





@property (nonatomic, strong) NSNumber* balanceScore;



@property int16_t balanceScoreValue;
- (int16_t)balanceScoreValue;
- (void)setBalanceScoreValue:(int16_t)value_;

//- (BOOL)validateBalanceScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* bodyAge;



@property int16_t bodyAgeValue;
- (int16_t)bodyAgeValue;
- (void)setBodyAgeValue:(int16_t)value_;

//- (BOOL)validateBodyAge:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* brainAge;



@property int16_t brainAgeValue;
- (int16_t)brainAgeValue;
- (void)setBrainAgeValue:(int16_t)value_;

//- (BOOL)validateBrainAge:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* calculateScore;



@property int16_t calculateScoreValue;
- (int16_t)calculateScoreValue;
- (void)setCalculateScoreValue:(int16_t)value_;

//- (BOOL)validateCalculateScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) AEUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _AEResult (CoreDataGeneratedAccessors)

@end

@interface _AEResult (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBalanceScore;
- (void)setPrimitiveBalanceScore:(NSNumber*)value;

- (int16_t)primitiveBalanceScoreValue;
- (void)setPrimitiveBalanceScoreValue:(int16_t)value_;




- (NSNumber*)primitiveBodyAge;
- (void)setPrimitiveBodyAge:(NSNumber*)value;

- (int16_t)primitiveBodyAgeValue;
- (void)setPrimitiveBodyAgeValue:(int16_t)value_;




- (NSNumber*)primitiveBrainAge;
- (void)setPrimitiveBrainAge:(NSNumber*)value;

- (int16_t)primitiveBrainAgeValue;
- (void)setPrimitiveBrainAgeValue:(int16_t)value_;




- (NSNumber*)primitiveCalculateScore;
- (void)setPrimitiveCalculateScore:(NSNumber*)value;

- (int16_t)primitiveCalculateScoreValue;
- (void)setPrimitiveCalculateScoreValue:(int16_t)value_;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;





- (AEUser*)primitiveUser;
- (void)setPrimitiveUser:(AEUser*)value;


@end
