#import "MusicSpringboard.h"
#import "MusicPreferences.h"

static NSInteger style;
static BOOL hideAlbumArtwork;
static BOOL hideRoutingButton;
static BOOL isIpad;

// ------------------ CSMediaControlsViewController ------------------

%hook CSMediaControlsViewController

- (CGRect)_suggestedFrameForMediaControls
{
	CGRect frame = %orig;
	frame.size.height = style == 0 ? 110 : 145;
	return frame;
}

%end

%hook MRPlatterViewController

- (void)viewWillLayoutSubviews
{
	%orig;

	if([[self parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
	{
		if(!hideRoutingButton)
			[[[self nowPlayingHeaderView] routingButton] setTransform: CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)];

		if(style != 1)
			[[[[self parentContainerView] containerView] timeControl] removeFromSuperview];
		if(style != 2)
			[[self volumeContainerView] removeFromSuperview];
	}
}

%end

// ------------------ MediaControlsHeaderView ------------------

%hook MediaControlsHeaderView

- (void)setFrame: (CGRect)frame
{
	if([[[self _viewControllerForAncestor] parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
		frame.size.width = isIpad ? 380 : 190;
	%orig;
}

- (CGRect)frame
{
	CGRect frame = %orig;
	if([[[self _viewControllerForAncestor] parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
		frame.size.width = isIpad ? 380 : 190;
	return frame;
}

- (CGSize)layoutTextInAvailableBounds: (CGRect)frame setFrames: (BOOL)arg2
{
	if([[[self _viewControllerForAncestor] parentViewController] isKindOfClass: %c(CSMediaControlsViewController)])
	{
		if(hideAlbumArtwork)
		{
			frame.origin.x = 18;
			frame.size.width = isIpad ? 370 : 200;
		}
		else
			frame.size.width = isIpad ? 300 : 135;
	}

	return %orig;
}

- (UIView*)hitTest: (CGPoint)point withEvent: (UIEvent*)event
{
    CGPoint translatedPoint = [[self routingButton] convertPoint: point fromView: self];

    if(CGRectContainsPoint([[self routingButton] bounds], translatedPoint))
        return [[self routingButton] hitTest: translatedPoint withEvent: event];
    
    return %orig;

}

- (BOOL)pointInside: (CGPoint)point withEvent: (UIEvent*)event
{
	if(CGRectContainsPoint([[self routingButton] frame], point))
		return YES;
	
	return %orig;
}

%end

%hook MediaControlsRoutingButtonView

- (void)setFrame: (CGRect)frame
{
	if(!hideRoutingButton && [[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
	{
		int x;
		if(isIpad)
		{	
			if(NSClassFromString(@"NextUpMediaHeaderView"))
				x = 502;
			else
				x = 512;
		}
		else
		{
			if(NSClassFromString(@"NextUpMediaHeaderView"))
				x = 303;
			else
				x = 315;
		}
		frame.origin.x = x;
		frame.origin.y = -20;
	}
	%orig;
}

- (CGRect)frame
{
	CGRect frame = %orig;
	if(!hideRoutingButton && [[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
	{
		int x;
		if(isIpad)
		{
			if(NSClassFromString(@"NextUpMediaHeaderView"))
				x = 502;
			else
				x = 512;
		}
		else
		{
			if(NSClassFromString(@"NextUpMediaHeaderView"))
				x = 303;
			else
				x = 315;
		}
		frame.origin.x = x;
		frame.origin.y = -20;
	}
	return frame;
}

%end

// ------------------ MediaControlsParentContainerView ------------------

%hook MediaControlsParentContainerView

- (void)setFrame: (CGRect)frame
{
	if([[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
		frame = [[self superview] frame];
	%orig;
}

- (CGRect)frame
{
	CGRect frame = %orig;
	if([[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
		frame = [[self superview] frame];
	return frame;
}

%end

// ------------------ MediaControlsContainerView ------------------

%hook MediaControlsContainerView

- (void)setFrame: (CGRect)frame
{
	if([[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
		frame = [[self superview] frame];
	%orig;
}

- (CGRect)frame
{
	CGRect frame = %orig;
	if([[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
		frame = [[self superview] frame];
	return frame;
}

- (void)layoutSubviews
{
	%orig;

	if([[self _rootView] isKindOfClass: %c(SBCoverSheetWindow)])
	{
		[[self transportStackView] setFrame: CGRectMake(isIpad ? 382 : 200, 37, 150, 35)];

		MediaControlsTimeControl *timeControl = [self timeControl];
		if(style == 1)
		{
			CGRect timeFrame = [timeControl frame];
			timeFrame.origin.y = 80;
			[timeControl setFrame: timeFrame];
		}	
		else
			[timeControl removeFromSuperview];
	}
}

%end

void initCompactMediaPlayer()
{
	style = [[MusicPreferences sharedInstance] lockScreenMusicWidgetCompactStyle];
	hideAlbumArtwork = [[MusicPreferences sharedInstance] hideAlbumArtwork];
	hideRoutingButton = [[MusicPreferences sharedInstance] hideRoutingButton];
	isIpad = [[MusicPreferences sharedInstance] isIpad];

	%init;
}
