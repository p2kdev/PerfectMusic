#import <Cephei/HBPreferences.h>

@interface MusicPreferences: NSObject
{
	HBPreferences *_preferences;

	BOOL _enabled;

	//General
	BOOL _enabledMediaControlWithVolumeButtons;
	BOOL _swapVolumeButtonsOnLandscapeLeft;

	BOOL _showNotification;

	//Springboard
	BOOL _showExtraButtons;
	BOOL _colorizeLockScreenMusicWidget;
	NSInteger _lockScreenMusicWidgetCornerRadius;
	BOOL _disableTopLeftCornerRadius;
	BOOL _disableTopRightCornerRadius;
	BOOL _disableBottomLeftCornerRadius;
	BOOL _disableBottomRightCornerRadius;
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
	BOOL _enableMusicAppCustomTint;
	UIColor *_customMusicAppTintColor;
}
+ (instancetype)sharedInstance;
- (BOOL)enabled;
- (BOOL)showNotification;
- (BOOL)enabledMediaControlWithVolumeButtons;
- (BOOL)swapVolumeButtonsOnLandscapeLeft;
- (BOOL)showExtraButtons;
- (BOOL)colorizeLockScreenMusicWidget;
- (NSInteger)lockScreenMusicWidgetCornerRadius;
- (BOOL)disableTopLeftCornerRadius;
- (BOOL)disableTopRightCornerRadius;
- (BOOL)disableBottomLeftCornerRadius;
- (BOOL)disableBottomRightCornerRadius;
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
- (BOOL)enableMusicAppCustomTint;
- (UIColor*)customMusicAppTintColor;
- (BOOL)isIpad;
@end
