#import <Cephei/HBPreferences.h>

@interface MusicPreferences: NSObject
{
	HBPreferences *_preferences;

	BOOL _enabled;

	//Springboard
	BOOL _colorizeLockScreenMusicWidget;
	NSInteger _lockScreenMusicWidgetCornerRadius;
	BOOL _addLockScreenMusicWidgetBorder;
	NSInteger _lockScreenMusicWidgetBorderWidth;
	BOOL _colorizeControlCenterMusicWidget;
	BOOL _addControlCenterWidgetBorder;
	BOOL _vibrateMusicWidget;

	//MusicApp
	BOOL _colorizeMusicApp;
	BOOL _addMusicAppBorder;
	NSInteger _musicAppBorderWidth;
	BOOL __3AlbumsPerLine;
	BOOL _hideQueueHUD;
	BOOL _vibrateMusicApp;
}
+ (instancetype)sharedInstance;
- (BOOL)enabled;
- (BOOL)colorizeLockScreenMusicWidget;
- (NSInteger)lockScreenMusicWidgetCornerRadius;
- (BOOL)addLockScreenMusicWidgetBorder;
- (NSInteger)lockScreenMusicWidgetBorderWidth;
- (BOOL)colorizeControlCenterMusicWidget;
- (BOOL)addControlCenterWidgetBorder;
- (BOOL)vibrateMusicWidget;
- (BOOL)colorizeMusicApp;
- (BOOL)addMusicAppBorder;
- (NSInteger)musicAppBorderWidth;
- (BOOL)_3AlbumsPerLine;
- (BOOL)hideQueueHUD;
- (BOOL)vibrateMusicApp;
@end
