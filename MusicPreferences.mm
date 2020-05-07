#import "MusicPreferences.h"

#define IS_iPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@implementation MusicPreferences

+ (instancetype)sharedInstance
{
	static MusicPreferences *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, 
	^{
		sharedInstance = [[MusicPreferences alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
	self = [super init];

	_preferences = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectmusic13prefs"];
	[_preferences registerDefaults:
	@{
		@"enabled": @NO,

		//General
		@"enabledMediaControlWithVolumeButtons": @NO,
		@"swapVolumeButtonsOnLandscapeLeft": @NO,
		@"showNotification": @NO,

		//Springboard
		@"showExtraButtons": @NO,
		@"colorizeLockScreenMusicWidget": @NO,
		@"lockScreenMusicWidgetCornerRadius": @13,
		@"disableTopLeftCornerRadius": @NO,
		@"disableTopRightCornerRadius": @NO,
		@"disableBottomLeftCornerRadius": @NO,
		@"disableBottomRightCornerRadius": @NO,
		@"addLockScreenMusicWidgetBorder": @NO,
		@"lockScreenMusicWidgetBorderWidth": @3,
		@"colorizeControlCenterMusicWidget": @NO,
		@"addControlCenterWidgetBorder": @NO,
		@"vibrateMusicWidget": @NO,

		//MusicApp
		@"colorizeMusicApp": @NO,
		@"addMusicAppBorder": @NO,
		@"musicAppBorderWidth": @4,
		@"_3AlbumsPerLine": @NO,
		@"hideQueueHUD": @NO,
		@"vibrateMusicApp": @NO
	}];

	_enabled = [_preferences boolForKey: @"enabled"];

	_enabledMediaControlWithVolumeButtons = [_preferences boolForKey: @"enabledMediaControlWithVolumeButtons"];
	_swapVolumeButtonsOnLandscapeLeft = [_preferences boolForKey: @"swapVolumeButtonsOnLandscapeLeft"];
	_showNotification = [_preferences boolForKey: @"showNotification"];

	_showExtraButtons = [_preferences boolForKey: @"showExtraButtons"];
	_colorizeLockScreenMusicWidget = [_preferences boolForKey: @"colorizeLockScreenMusicWidget"];
	_lockScreenMusicWidgetCornerRadius = [_preferences integerForKey: @"lockScreenMusicWidgetCornerRadius"];
	_disableTopLeftCornerRadius = [_preferences boolForKey: @"disableTopLeftCornerRadius"];
	_disableTopRightCornerRadius = [_preferences boolForKey: @"disableTopRightCornerRadius"];
	_disableBottomLeftCornerRadius = [_preferences boolForKey: @"disableBottomLeftCornerRadius"];
	_disableBottomRightCornerRadius = [_preferences boolForKey: @"disableBottomRightCornerRadius"];
	_addLockScreenMusicWidgetBorder = [_preferences boolForKey: @"addLockScreenMusicWidgetBorder"];
	_lockScreenMusicWidgetBorderWidth = [_preferences integerForKey: @"lockScreenMusicWidgetBorderWidth"];
	_colorizeControlCenterMusicWidget = [_preferences boolForKey: @"colorizeControlCenterMusicWidget"];
	_addControlCenterWidgetBorder = [_preferences boolForKey: @"addControlCenterWidgetBorder"];
	_vibrateMusicWidget = [_preferences boolForKey: @"vibrateMusicWidget"];

	_colorizeMusicApp = [_preferences boolForKey: @"colorizeMusicApp"];
	_addMusicAppBorder = [_preferences boolForKey: @"addMusicAppBorder"];
	_musicAppBorderWidth = [_preferences integerForKey: @"musicAppBorderWidth"];
	__3AlbumsPerLine = [_preferences boolForKey: @"_3AlbumsPerLine"];
	_hideQueueHUD = [_preferences boolForKey: @"hideQueueHUD"];
	_vibrateMusicApp = [_preferences boolForKey: @"vibrateMusicApp"];

	return self;
}

- (BOOL)enabled
{
	return _enabled;
}

- (BOOL)enabledMediaControlWithVolumeButtons
{
	return _enabledMediaControlWithVolumeButtons;
}

- (BOOL)swapVolumeButtonsOnLandscapeLeft
{
	return _swapVolumeButtonsOnLandscapeLeft;
}

- (BOOL)showNotification
{
	return _showNotification;
}

- (BOOL)showExtraButtons
{
	return _showExtraButtons;
}

- (BOOL)colorizeLockScreenMusicWidget
{
	return _colorizeLockScreenMusicWidget;
}

- (NSInteger)lockScreenMusicWidgetCornerRadius
{
	return _lockScreenMusicWidgetCornerRadius;
}

- (BOOL)disableTopLeftCornerRadius
{
	return _disableTopLeftCornerRadius;
}

- (BOOL)disableTopRightCornerRadius
{
	return _disableTopRightCornerRadius;
}

- (BOOL)disableBottomLeftCornerRadius
{
	return _disableBottomLeftCornerRadius;
}

- (BOOL)disableBottomRightCornerRadius
{
	return _disableBottomRightCornerRadius;
}

- (BOOL)addLockScreenMusicWidgetBorder
{
	return _addLockScreenMusicWidgetBorder;
}

- (NSInteger )lockScreenMusicWidgetBorderWidth
{
	return _lockScreenMusicWidgetBorderWidth;
}

- (BOOL)colorizeControlCenterMusicWidget
{
	return _colorizeControlCenterMusicWidget;
}

- (BOOL)addControlCenterWidgetBorder
{
	return _addControlCenterWidgetBorder;
}

- (BOOL)vibrateMusicWidget
{
	return _vibrateMusicWidget;
}

- (BOOL)colorizeMusicApp
{
	return _colorizeMusicApp;
}

- (BOOL)addMusicAppBorder
{
	return _addMusicAppBorder;
}

- (NSInteger )musicAppBorderWidth
{
	return _musicAppBorderWidth;
}

- (BOOL)_3AlbumsPerLine
{
	return __3AlbumsPerLine;
}

- (BOOL)hideQueueHUD
{
	return _hideQueueHUD;
}

- (BOOL)vibrateMusicApp
{
	return _vibrateMusicApp;
}

- (BOOL)isIpad
{
	return IS_iPAD;
}

@end