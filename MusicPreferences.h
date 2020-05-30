#import <Cephei/HBPreferences.h>

@interface MusicPreferences: NSObject
{
	HBPreferences *_preferences;
}
@property(nonatomic, readonly) BOOL enabled;
@property(nonatomic, readonly) BOOL showNotification;
@property(nonatomic, readonly) BOOL enabledMediaControlWithVolumeButtons;
@property(nonatomic, readonly) BOOL swapVolumeButtonsOnLandscapeLeft;
@property(nonatomic, readonly) BOOL addExtraButtonsToLockScreen;
@property(nonatomic, readonly) BOOL addExtraButtonsToControlCenter;
@property(nonatomic, readonly) BOOL colorizeLockScreenMusicWidget;
@property(nonatomic, readonly) CGFloat lockScreenMusicWidgetBackgroundColorAlpha;
@property(nonatomic, readonly) NSInteger lockScreenMusicWidgetCornerRadius;
@property(nonatomic, readonly) BOOL disableTopLeftCornerRadius;
@property(nonatomic, readonly) BOOL disableTopRightCornerRadius;
@property(nonatomic, readonly) BOOL disableBottomLeftCornerRadius;
@property(nonatomic, readonly) BOOL disableBottomRightCornerRadius;
@property(nonatomic, readonly) BOOL addLockScreenMusicWidgetBorder;
@property(nonatomic, readonly) CGFloat lockScreenMusicWidgetBorderColorAlpha;
@property(nonatomic, readonly) NSInteger lockScreenMusicWidgetBorderWidth;
@property(nonatomic, readonly) BOOL colorizeControlCenterMusicWidget;
@property(nonatomic, readonly) CGFloat controlCenterMusicWidgetBackgroundColorAlpha;
@property(nonatomic, readonly) BOOL addControlCenterWidgetBorder;
@property(nonatomic, readonly) CGFloat controlCenterMusicWidgetBorderColorAlpha;
@property(nonatomic, readonly) BOOL vibrateMusicWidget;
@property(nonatomic, readonly) BOOL colorizeMusicApp;
@property(nonatomic, readonly) BOOL addMusicAppBorder;
@property(nonatomic, readonly) NSInteger musicAppBorderWidth;
@property(nonatomic, readonly) BOOL _3AlbumsPerLine;
@property(nonatomic, readonly) BOOL hideQueueHUD;
@property(nonatomic, readonly) BOOL vibrateMusicApp;
@property(nonatomic, readonly) BOOL enableMusicAppCustomTint;
@property(nonatomic, readonly) UIColor *customMusicAppTintColor;

@property(nonatomic, readonly) BOOL isIpad;

+ (id)sharedInstance;
@end
