#include <CoreFoundation/CFString.h>

@interface UIKeyboardImpl

- (NSString *)hankana:(NSString *)string;
- (void)setCandidates:(id)arg1;
- (id)inputStringFromPhraseBoundary;

@end

@interface TIKeyboardCandidate

@end

@interface TIKeyboardCandidateResultSet

- (NSArray *)candidates;
- (BOOL)hasCandidates;
+ (id)setWithCandidates:(id)arg1;
- (TIKeyboardCandidate *)defaultCandidate;
- (NSArray *)sortMethods;
- (void)setGeneratedCandidateCount:(unsigned long long)arg1;
- (void)setDefaultCandidate:(TIKeyboardCandidate *)arg1;
- (void)setSortMethods:(NSArray *)arg1;

@end

@interface TIKeyboardCandidateSingle

+ (id)candidateWithCandidate:(id)arg1 forInput:(id)arg2;

@end

%hook UIKeyboardImpl

%new
- (NSString *)hankana:(NSString *)string {
  NSMutableString *mutableString = [string mutableCopy];
	CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformHiraganaKatakana, NO);
	CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformFullwidthHalfwidth, NO);
	return [mutableString precomposedStringWithCanonicalMapping];
}

- (void)setCandidates:(TIKeyboardCandidateResultSet *)resultSet {
	if ([resultSet hasCandidates]) {
		NSString *input = [self inputStringFromPhraseBoundary];
		if (input) {
			NSMutableArray *mutableCandidates = [NSMutableArray arrayWithArray:[resultSet candidates]];
			int index = 2;
			if ([mutableCandidates count] <= 2) {
				index = [mutableCandidates count];
			}
			TIKeyboardCandidateSingle *hankakuCandidate = [objc_getClass("TIKeyboardCandidateSingle") candidateWithCandidate:[self hankana:input] forInput:input];
			[mutableCandidates insertObject:hankakuCandidate atIndex:index];
			NSArray *sortMethods = [NSArray arrayWithArray:[resultSet sortMethods]];
			TIKeyboardCandidate *defaultCandidate = [resultSet defaultCandidate];
			resultSet = [objc_getClass("TIKeyboardCandidateResultSet") setWithCandidates:[NSArray arrayWithArray:mutableCandidates]];
			[resultSet setGeneratedCandidateCount:[[resultSet candidates] count]];
			[resultSet setSortMethods:sortMethods];
			[resultSet setDefaultCandidate:defaultCandidate];
		}
	}
	%orig;
}

%end