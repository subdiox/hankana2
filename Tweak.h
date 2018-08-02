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

@interface TIMecabraCandidate

// iOS 11
- (id)initWithCandidate:(id)arg1 forInput:(id)arg2 mecabraCandidatePointerValue:(id)arg3 withFlags:(int)arg4;
// iOS 10
- (id)initWithCandidate:(id)arg1 forInput:(id)arg2 mecabraCandidatePointerValue:(id)arg3 isExtension:(BOOL)arg4 isEmoji:(BOOL)arg5 isShortcut:(BOOL)arg6 isAutocorrection:(BOOL)arg7;
// iOS 9 and below
- (id)initWithCandidate:(id)arg1 forInput:(id)arg2 mecabraCandidatePointerValue:(id)arg3 isExtension:(BOOL)arg4 isEmoji:(BOOL)arg5 isShortcut:(BOOL)arg6;

@end
