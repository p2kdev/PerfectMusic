#import "MusicPreferences.h"
#import "SparkColourPickerUtils.h"

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
		@"swapVolumeButtonsBasedOnOrientation": @NO,
		@"showNotification": @NO,

		//Springboard
		@"addExtraButtonsToLockScreen": @NO,
		@"addExtraButtonsToControlCenter": @NO,

		@"colorizeLockScreenMusicWidget": @NO,
		@"hideAlbumArtwork": @NO,
		@"hideRoutingButton": @NO,
		@"lockScreenMusicWidgetStyle": @0,
		@"lockScreenMusicWidgetCompactStyle": @0,
		@"lockScreenMusicWidgetBackgroundColorAlpha": @1.0,
		@"lockScreenMusicWidgetCornerRadius": @13,
		@"disableTopLeftCornerRadius": @NO,
		@"disableTopRightCornerRadius": @NO,
		@"disableBottomLeftCornerRadius": @NO,
		@"disableBottomRightCornerRadius": @NO,
		@"addLockScreenMusicWidgetBorder": @NO,
		@"lockScreenMusicWidgetBorderColorAlpha": @1.0,
		@"lockScreenMusicWidgetBorderWidth": @3,

		@"colorizeControlCenterMusicWidget": @NO,
		@"controlCenterMusicWidgetBackgroundColorAlpha": @1.0,
		@"addControlCenterWidgetBorder": @NO,
		@"controlCenterMusicWidgetBorderColorAlpha": @1.0,

		@"vibrateMusicWidget": @NO,

		//MusicApp
		@"colorizeMusicApp": @NO,
		@"colorizeNowPlayingView": @NO,
		@"colorizeQueueView": @NO,
		@"colorizeMiniPlayerView": @NO,
		@"addMusicAppBorder": @NO,
		@"hideAlbumShadow": @NO,
		@"musicAppBorderWidth": @4,
		@"enableCustomRecentlyAddedColumnsNumber": @NO,
		@"customRecentlyAddedColumnsNumber": @3,
		@"hideQueueHUD": @NO,
		@"hideKeepOrClearAlert": @NO,
		@"keepOrClearAlertAction": @1,
		@"hideSeparators": @NO,
		@"vibrateMusicApp": @NO,
		@"enableMusicAppCustomTint": @NO,
		@"enableMusicAppNowPlayingViewCustomTint": @NO,
		@"enableMusicAppNowPlayingViewCustomBackgroundColor": @NO,
		@"enableMusicAppNowPlayingViewCustomBorderColor": @NO,
	}];

	_enabled = [_preferences boolForKey: @"enabled"];

	_enabledMediaControlWithVolumeButtons = [_preferences boolForKey: @"enabledMediaControlWithVolumeButtons"];
	_swapVolumeButtonsBasedOnOrientation = [_preferences boolForKey: @"swapVolumeButtonsBasedOnOrientation"];
	_showNotification = [_preferences boolForKey: @"showNotification"];

	_addExtraButtonsToLockScreen = [_preferences boolForKey: @"addExtraButtonsToLockScreen"];
	_addExtraButtonsToControlCenter = [_preferences boolForKey: @"addExtraButtonsToControlCenter"];

	_colorizeLockScreenMusicWidget = [_preferences boolForKey: @"colorizeLockScreenMusicWidget"];
	_hideAlbumArtwork = [_preferences boolForKey: @"hideAlbumArtwork"];
	_hideRoutingButton = [_preferences boolForKey: @"hideRoutingButton"];
	_lockScreenMusicWidgetStyle = [_preferences integerForKey: @"lockScreenMusicWidgetStyle"];
	_lockScreenMusicWidgetCompactStyle = [_preferences integerForKey: @"lockScreenMusicWidgetCompactStyle"];
	_lockScreenMusicWidgetBackgroundColorAlpha = [_preferences doubleForKey: @"lockScreenMusicWidgetBackgroundColorAlpha"];
	_lockScreenMusicWidgetCornerRadius = [_preferences integerForKey: @"lockScreenMusicWidgetCornerRadius"];
	_disableTopLeftCornerRadius = [_preferences boolForKey: @"disableTopLeftCornerRadius"];
	_disableTopRightCornerRadius = [_preferences boolForKey: @"disableTopRightCornerRadius"];
	_disableBottomLeftCornerRadius = [_preferences boolForKey: @"disableBottomLeftCornerRadius"];
	_disableBottomRightCornerRadius = [_preferences boolForKey: @"disableBottomRightCornerRadius"];
	_addLockScreenMusicWidgetBorder = [_preferences boolForKey: @"addLockScreenMusicWidgetBorder"];
	_lockScreenMusicWidgetBorderColorAlpha = [_preferences doubleForKey: @"lockScreenMusicWidgetBorderColorAlpha"];
	_lockScreenMusicWidgetBorderWidth = [_preferences integerForKey: @"lockScreenMusicWidgetBorderWidth"];

	_colorizeControlCenterMusicWidget = [_preferences boolForKey: @"colorizeControlCenterMusicWidget"];
	_controlCenterMusicWidgetBackgroundColorAlpha = [_preferences doubleForKey: @"controlCenterMusicWidgetBackgroundColorAlpha"];
	_addControlCenterWidgetBorder = [_preferences boolForKey: @"addControlCenterWidgetBorder"];
	_controlCenterMusicWidgetBorderColorAlpha = [_preferences doubleForKey: @"controlCenterMusicWidgetBorderColorAlpha"];
	
	_vibrateMusicWidget = [_preferences boolForKey: @"vibrateMusicWidget"];

	_colorizeMusicApp = [_preferences boolForKey: @"colorizeMusicApp"];
	_colorizeNowPlayingView = [_preferences boolForKey: @"colorizeNowPlayingView"];
	_colorizeQueueView = [_preferences boolForKey: @"colorizeQueueView"];
	_colorizeMiniPlayerView = [_preferences boolForKey: @"colorizeMiniPlayerView"];
	_addMusicAppBorder = [_preferences boolForKey: @"addMusicAppBorder"];
	_hideAlbumShadow = [_preferences boolForKey: @"hideAlbumShadow"];
	_musicAppBorderWidth = [_preferences integerForKey: @"musicAppBorderWidth"];
	_enableCustomRecentlyAddedColumnsNumber = [_preferences boolForKey: @"enableCustomRecentlyAddedColumnsNumber"];
	_customRecentlyAddedColumnsNumber = [_preferences integerForKey: @"customRecentlyAddedColumnsNumber"];
	_hideQueueHUD = [_preferences boolForKey: @"hideQueueHUD"];
	_hideKeepOrClearAlert = [_preferences boolForKey: @"hideKeepOrClearAlert"];
	_keepOrClearAlertAction = [_preferences integerForKey: @"keepOrClearAlertAction"];
	_hideSeparators = [_preferences boolForKey: @"hideSeparators"];
	_vibrateMusicApp = [_preferences boolForKey: @"vibrateMusicApp"];
	_enableMusicAppCustomTint = [_preferences boolForKey: @"enableMusicAppCustomTint"];
	_enableMusicAppNowPlayingViewCustomTint = [_preferences boolForKey: @"enableMusicAppNowPlayingViewCustomTint"];
	_enableMusicAppNowPlayingViewCustomBackgroundColor = [_preferences boolForKey: @"enableMusicAppNowPlayingViewCustomBackgroundColor"];
	_enableMusicAppNowPlayingViewCustomBorderColor = [_preferences boolForKey: @"enableMusicAppNowPlayingViewCustomBorderColor"];
	if(_enableMusicAppCustomTint || _enableMusicAppNowPlayingViewCustomTint || _enableMusicAppNowPlayingViewCustomBackgroundColor || _enableMusicAppNowPlayingViewCustomBorderColor)
	{
		NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.perfectmusic13prefs.colors.plist"];
		_customMusicAppTintColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customMusicAppTintColor"] withFallback: @"#FF9400"];
		_customMusicAppNowPlayingViewTintColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customMusicAppNowPlayingViewTintColor"] withFallback: @"#FF9400"];
		_customMusicAppNowPlayingViewBackgroundColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customMusicAppNowPlayingViewBackgroundColor"] withFallback: @"#FFFFFF"];
		_customMusicAppNowPlayingViewBorderColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customMusicAppNowPlayingViewBorderColor"] withFallback: @"#FF9400"];
	}

	return self;
}

- (BOOL)isIpad
{
	return IS_iPAD;
}

@end