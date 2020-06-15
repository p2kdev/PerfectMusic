@interface SBApplication: NSObject
- (NSString*)bundleIdentifier;
@end

@interface SpringBoard: UIApplication
- (SBApplication*)_accessibilityFrontMostApplication;
- (void)invalidateForward;
- (void)invalidateBack;
@end

@interface SBVolumeControl
- (void)changeVolumeByDelta: (float)arg1;
@end