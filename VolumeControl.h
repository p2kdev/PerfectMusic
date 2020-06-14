@interface SBApplication: NSObject
- (NSString*)bundleIdentifier;
@end

@interface SpringBoard: UIApplication
- (SBApplication*)_accessibilityFrontMostApplication;
- (void)goForward;
- (void)goBackward;
@end

@interface SBVolumeControl
- (void)changeVolumeByDelta: (float)arg1;
@end