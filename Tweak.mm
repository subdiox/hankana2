#include "Tweak.h"
#include <CoreFoundation/CFString.h>

%hook UIKeyboardImpl

%new
- (NSString *)hankana:(NSString *)string {
  NSMutableString *mutableString = [string mutableCopy];
	CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformHiraganaKatakana, NO);
	CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformFullwidthHalfwidth, NO);
	return [NSString stringWithString:mutableString];
}

- (void)setCandidates:(TIKeyboardCandidateResultSet *)resultSet {
	if ([resultSet hasCandidates]) {
		NSString *input = [self inputStringFromPhraseBoundary];
		if (input) {
			NSMutableArray *mutableCandidates = [NSMutableArray arrayWithArray:[resultSet candidates]];
			int index = 2;
			if ([mutableCandidates count] <= 2) {
				index = 0;
			}
			if (@available(iOS 11.0, *)) {
				TIMecabraCandidate *hankakuCandidate = [[objc_getClass("TIMecabraCandidate") alloc] initWithCandidate:[self hankana:input] forInput:input mecabraCandidatePointerValue:nil withFlags:nil];
				[mutableCandidates insertObject:hankakuCandidate atIndex:index];
			} else if (@available(iOS 10.0, *)) {
				TIMecabraCandidate *hankakuCandidate = [[objc_getClass("TIMecabraCandidate") alloc] initWithCandidate:[self hankana:input] forInput:input mecabraCandidatePointerValue:nil isExtension:NO isEmoji:NO isShortcut:NO isAutocorrection:NO];
				[mutableCandidates insertObject:hankakuCandidate atIndex:index];
			} else {
				TIMecabraCandidate *hankakuCandidate = [[objc_getClass("TIMecabraCandidate") alloc] initWithCandidate:[self hankana:input] forInput:input mecabraCandidatePointerValue:nil isExtension:NO isEmoji:NO isShortcut:NO];
				[mutableCandidates insertObject:hankakuCandidate atIndex:index];
			}
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
