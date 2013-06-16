//
//  ZinniaRecognizer.m
//  iBrainAge
//
//  Created by saiten on 2013/01/05.
//
//

#import "ZinniaRecognizer.h"
#import "zinnia.h"

#define kZinniaRecognizerBestSize (1)

@implementation ZinniaRecognizer {
    zinnia_recognizer_t *_recognizer;
    zinnia_character_t *_character;
    CGSize _size;
    NSUInteger _count;
}

- (id)initWithModelFilePath:(NSString *)path
{
    self = [super init];
    if(self) {
		_recognizer = zinnia_recognizer_new();
		if (!zinnia_recognizer_open(_recognizer, [path cStringUsingEncoding:NSASCIIStringEncoding])) {
			NSLog(@"model open error: %s\n", zinnia_recognizer_strerror(_recognizer));
		}
        _character = zinnia_character_new();
        zinnia_character_clear(_character);
        
        self.separateStorokeCount = 1;
    }
    
    return self;
}

- (void)dealloc
{
    zinnia_recognizer_destroy(_recognizer);
    zinnia_character_destroy(_character);
}

- (CGSize)size
{
    return _size;
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self clear];
    zinnia_character_set_width(_character, size.width);
    zinnia_character_set_height(_character, size.height);
}

- (void)clear
{
    _count = 0;
    zinnia_character_clear(_character);
}

- (NSArray *)classify:(NSArray *)points
{
    for (int i = 0; i < points.count; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        zinnia_character_add(_character, _count, point.x, point.y);
    }
    
    zinnia_result_t *result;
    result = zinnia_recognizer_classify(_recognizer, _character, kZinniaRecognizerBestSize);
    if(result == NULL) {
        NSLog(@"classify error: %s\n", zinnia_recognizer_strerror(_recognizer));
        return nil;
    }
    
	NSMutableArray *results = [NSMutableArray array];
	for (int i = 0; i < zinnia_result_size(result); ++i) {
		NSString *value = [NSString stringWithCString:zinnia_result_value(result, i) encoding:NSUTF8StringEncoding];
		NSNumber *score = [NSNumber numberWithFloat:zinnia_result_score(result, i)];
        
		ZinniaResult *result = [ZinniaResult new];
		result.value = value;
		result.score = score;
		[results addObject:result];
	}
	zinnia_result_destroy(result);
    
    [results sortUsingComparator:^NSComparisonResult(ZinniaResult *r1, ZinniaResult *r2) {
        return [r2.score floatValue] - [r1.score floatValue];
    }];;
    
    _count++;
    
    return results;
}

- (NSArray*)classifyCharactersWithStrokes:(NSArray *)strokes
{
    NSMutableArray *classifiedCharacters = [NSMutableArray array];
    
    if(self.separateStorokeCount == 1) {
        NSArray *classifiedCharacter = [self classifyCharacterWithStrokes:strokes];
        [classifiedCharacters addObject:classifiedCharacter];
    } else {
        NSArray *strokeGroup = [self _separateStrokes:strokes];
        for(NSArray *stroke in strokeGroup) {
            NSArray *classifiedCharacter = [self classifyCharacterWithStrokes:stroke];
            [classifiedCharacters addObject:classifiedCharacter];
        }
    }
    
    return classifiedCharacters;
}

- (NSArray*)classifyCharacterWithStrokes:(NSArray *)strokes
{
    [self clear];

    NSArray *results = nil;
    for(NSArray *points in strokes) {
        results = [self classify:points];
    }
    
    return results;
}

- (NSArray *)_separateStrokes:(NSArray *)strokes
{
    NSMutableDictionary *centerStrokePair = [NSMutableDictionary dictionaryWithCapacity:strokes.count];
    NSMutableArray *centers = [NSMutableArray arrayWithCapacity:strokes.count];
    
    // 各ストロークの重心を計算
    for(NSArray *stroke in strokes) {
        CGPoint center = [self _calculateCenterOfGravityWithPoints:stroke];
        [centers addObject:[NSValue valueWithCGPoint:center]];
        [centerStrokePair setObject:stroke forKey:[NSValue valueWithCGPoint:center]];
    }
    
    // 各ストロークの重心をkmeans法によりクラスタリング
    NSArray *clusters = [self _calculateClusterUsingKMeans:centers
                                              clusterCount:self.separateStorokeCount];
    
    // クラスタの重心x方向でソート
    clusters = [clusters sortedArrayUsingComparator:^NSComparisonResult(NSArray *c1, NSArray *c2) {
        CGPoint p1 = [self _calculateCenterOfGravityWithPoints:c1];
        CGPoint p2 = [self _calculateCenterOfGravityWithPoints:c2];
        return p1.x - p2.x;
    }];
    
    // クラスタを基にストロークを分割
    NSMutableArray *strokeGroup = [NSMutableArray arrayWithCapacity:clusters.count];
    for(int i = 0; i < clusters.count; i++) {
        NSArray *centers = [clusters objectAtIndex:i];
        
        NSMutableArray *strokes = [NSMutableArray arrayWithCapacity:centers.count];
        for(NSValue *center in centers) {
            NSArray *stroke = [centerStrokePair objectForKey:center];
            [strokes addObject:stroke];
        }

        [strokeGroup addObject:strokes];
    }
    
    return strokeGroup;
}

- (NSArray*)_calculateClusterUsingKMeans:(NSArray*)points clusterCount:(NSUInteger)clusterCount
{
    CGPoint centersOfCluster[clusterCount];
    
    NSMutableArray *clusters = [NSMutableArray arrayWithCapacity:clusterCount];
    for(int i = 0; i < clusterCount; i++) {
        [clusters addObject:[NSMutableArray array]];
    }
    
    // 各点をランダムにクラスタに配置
    for(NSValue *pointValue in points) {
        int index = arc4random() % clusterCount;
        [[clusters objectAtIndex:index] addObject:pointValue];
    }
    
    BOOL changed;
    do {
        // 各クラスタの重心を計算
        for(int i = 0; i< clusterCount; i++) {
            NSArray *points = [clusters objectAtIndex:i];
            centersOfCluster[i] = [self _calculateCenterOfGravityWithPoints:points];
        }
    
        NSMutableArray *newClusters = [NSMutableArray arrayWithCapacity:clusterCount];
        for(int i = 0; i < clusterCount; i++) {
            [clusters addObject:[NSMutableArray array]];
        }
    
        // 各点から最も近い重心のクラスタに移動
        changed = NO;
        for(int i = 0; i < clusterCount; i++) {
        
            NSArray *points = [clusters objectAtIndex:i];
        
            for(NSValue *pointValue in points) {
                CGPoint point = [pointValue CGPointValue];

                // 一番近いクラスタの重心を探索
                CGFloat minDistance = MAXFLOAT;
                NSUInteger index = i;
            
                for(int j = 0; j < clusterCount; j++) {
                    CGPoint center = centersOfCluster[j];
                    CGFloat distance = sqrt(pow(center.x - point.x, 2.0f) + pow(center.y - point.y, 2.0f));
                    if(distance < minDistance) {
                        index = j;
                    }
                }

                if(i != index) {
                    changed = YES;
                }
                [[newClusters objectAtIndex:index] addObject:pointValue];
            }
        }
    
        clusters = newClusters;
        
    } while(!changed); // クラスタが変わらなくなるまで繰り返す
    
    return clusters;
}

- (CGPoint)_calculateCenterOfGravityWithPoints:(NSArray*)points
{
    if(points.count > 0) {
        return CGPointMake(0.0, 0.0);
    }
    
    CGPoint origin = [[points objectAtIndex:0] CGPointValue];
    CGPoint center = CGPointMake(0, 0);
    for(NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        center.x += point.x - origin.x;
        center.y += point.y - origin.y;
    }
    
    center.x /= points.count;
    center.y /= points.count;
    
    return CGPointMake(origin.x + center.x, origin.y + center.y);
}

@end
