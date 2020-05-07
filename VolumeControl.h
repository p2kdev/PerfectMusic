@interface MPCMediaRemoteController: NSObject
- (id)_init;
- (void)sendCommand: (unsigned)arg1 options: (id)arg2 completion: (/*^block*/ id)arg3;
@end

@interface AVSystemController
+ (id)sharedAVSystemController;
- (BOOL)getActiveCategoryVolume: (float*)volume andName: (id*)name;
- (BOOL)setActiveCategoryVolumeTo: (float)to;
@end

@interface SBApplication: NSObject
- (NSString*)bundleIdentifier;
@end

@interface UIApplication ()
- (UIDeviceOrientation)_frontMostAppOrientation;
@end

@interface SpringBoard: UIApplication
- (void)takeScreenshot;
- (SBApplication*)_accessibilityFrontMostApplication;
- (void)goForward;
- (void)goBackward;
@end
