#import "MusicPreferences.h"
#import "MusicSpringboard.h"

static MusicPreferences *preferences;

static void produceLightVibration()
{
	UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
	[gen prepare];
	[gen impactOccurred];
}

%group lockscreenMusicWidgetTransparentBackgroundGroup

	%hook CSAdjunctItemView

	- (void)layoutSubviews
	{
		%orig;

		if([self subviews] && [[self subviews] count] > 0 && [[self subviews][0] subviews] && [[[self subviews][0] subviews] count] > 0)
			[[[self subviews][0] subviews][0] setAlpha: 0];
	}

	%end

%end

%group vibrateMusicWidgetGroup

	%hook MediaControlsRoutingButtonView

	- (void)touchesBegan: (id)arg1 withEvent: (id)arg2
	{
		produceLightVibration();
		%orig;
	}

	%end

	%hook MediaControlsTransportButton

	- (void)touchesBegan: (id)arg1 withEvent: (id)arg2
	{
		produceLightVibration();
		%orig;
	}

	%end

	%hook MediaControlsTimeControl

	- (void)touchesBegan: (id)arg1 withEvent: (id)arg2
	{
		produceLightVibration();
		%orig;
	}

	%end

	%hook MediaControlsVolumeSlider

	- (void)touchesBegan: (id)arg1 withEvent: (id)arg2
	{
		produceLightVibration();
		%orig;
	}

	%end

%end

%group lockScreenMusicWidgetHideAlbumArtworkGroup

	%hook MediaControlsHeaderView

	- (void)layoutSubviews
	{
		%orig;

		if([preferences lockScreenMusicWidgetHideAlbumArtwork] && [[[self _viewControllerForAncestor] parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
		{
			[[self artworkBackground] removeFromSuperview];
			[[self placeholderArtworkView] removeFromSuperview];
			[[self artworkView] removeFromSuperview];
			[[self shadow] removeFromSuperview];
		}
	}

	%end

%end

%group lockScreenMusicWidgetHideRoutingButtonGroup

	%hook MRPlatterViewController

	- (void)viewDidLayoutSubviews
	{
		%orig;
		
		if([[self parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
			[[[self nowPlayingHeaderView] routingButton] removeFromSuperview];
	}

	%end

%end

void initMusicWidget_OtherOptions()
{
	preferences = [MusicPreferences sharedInstance];
	
	if([preferences lockscreenMusicWidgetTransparentBackground])
		%init(lockscreenMusicWidgetTransparentBackgroundGroup);

	if([preferences vibrateMusicWidget] && ![preferences isIpad])
		%init(vibrateMusicWidgetGroup);
	
	if([preferences lockScreenMusicWidgetHideAlbumArtwork])
		%init(lockScreenMusicWidgetHideAlbumArtworkGroup);

	if([preferences lockScreenMusicWidgetHideRoutingButton])
		%init(lockScreenMusicWidgetHideRoutingButtonGroup);
}