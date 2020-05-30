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
		@"swapVolumeButtonsOnLandscapeLeft": @NO,
		@"showNotification": @NO,

		//Springboard
		@"addExtraButtonsToLockScreen": @NO,
		@"addExtraButtonsToControlCenter": @NO,

		@"colorizeLockScreenMusicWidget": @NO,
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
		@"addMusicAppBorder": @NO,
		@"musicAppBorderWidth": @4,
		@"_3AlbumsPerLine": @NO,
		@"hideQueueHUD": @NO,
		@"vibrateMusicApp": @NO,
		@"enableMusicAppCustomTint": @NO
	}];

	_enabled = [_preferences boolForKey: @"enabled"];

	_enabledMediaControlWithVolumeButtons = [_preferences boolForKey: @"enabledMediaControlWithVolumeButtons"];
	_swapVolumeButtonsOnLandscapeLeft = [_preferences boolForKey: @"swapVolumeButtonsOnLandscapeLeft"];
	_showNotification = [_preferences boolForKey: @"showNotification"];

	_addExtraButtonsToLockScreen = [_preferences boolForKey: @"addExtraButtonsToLockScreen"];
	_addExtraButtonsToControlCenter = [_preferences boolForKey: @"addExtraButtonsToControlCenter"];

	_colorizeLockScreenMusicWidget = [_preferences boolForKey: @"colorizeLockScreenMusicWidget"];
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
	_addMusicAppBorder = [_preferences boolForKey: @"addMusicAppBorder"];
	_musicAppBorderWidth = [_preferences integerForKey: @"musicAppBorderWidth"];
	__3AlbumsPerLine = [_preferences boolForKey: @"_3AlbumsPerLine"];
	_hideQueueHUD = [_preferences boolForKey: @"hideQueueHUD"];
	_vibrateMusicApp = [_preferences boolForKey: @"vibrateMusicApp"];
	_enableMusicAppCustomTint = [_preferences boolForKey: @"enableMusicAppCustomTint"];
	if(_enableMusicAppCustomTint)
	{
		NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/com.johnzaro.perfectmusic13prefs.colors.plist"];
		_customMusicAppTintColor = [SparkColourPickerUtils colourWithString: [preferencesDictionary objectForKey: @"customMusicAppTintColor"] withFallback: @"#FF9400"];
	}

	return self;
}

- (BOOL)isIpad
{
	return IS_iPAD;
}

@end