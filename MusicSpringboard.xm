#import "MusicPreferences.h"
#import "MusicSpringboard.h"
#import "Colorizer.h"

static MusicPreferences *preferences;
static Colorizer *colorizer;

int cornerMask = 0;

// ----------------------------------------------------------------------------------------------
// ---------------- COLORIZE MEDIA PLAYER LOCK SCREEN & CONTROL CENTER WIDGETS ------------------
// ----------------------------------------------------------------------------------------------

static void colorizeUIView(UIView *view, UIColor *backgroundColor, UIColor *tintColor, MTVisualStylingProvider *visualStylingProvider)
{
	[[view layer] setFilters: nil];
	if(backgroundColor) [view setBackgroundColor: backgroundColor];
	if(tintColor) [view setTintColor: tintColor];
	if(visualStylingProvider) [visualStylingProvider stopAutomaticallyUpdatingView: view];
}

static void colorizeUILabel(UILabel *label, UIColor *textColor, MTVisualStylingProvider *visualStylingProvider)
{
	if(visualStylingProvider) [visualStylingProvider stopAutomaticallyUpdatingView: label];
	[label mt_removeAllVisualStyling];
	if(textColor) [label setTextColor: textColor];
}

static void produceLightVibration()
{
	UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
	[gen prepare];
	[gen impactOccurred];
}

%group colorizeWidgetGroup

	%hook MRPlatterViewController

	%new
	- (void)colorize
	{
		MediaControlsHeaderView *nowPlayingHeaderView = [self nowPlayingHeaderView];

		// NEED TO FIND A BETTER SOLUTION FOR CHECKING IF SELF IS THE CONTROLLER OF LOCK SCREEN'S WIDGET OR CONTROL CENTER'S WIDGET

		if([preferences colorizeLockScreenMusicWidget] && [[[[nowPlayingHeaderView superview] superview] superview] isKindOfClass: %c(CSMediaControlsView)])
		{
			[nowPlayingHeaderView colorize];
			[[[[self parentContainerView] containerView] timeControl] colorize];
			[[[[self parentContainerView] containerView] transportStackView] colorize];
			[[[self volumeContainerView] volumeSlider] colorize];

			for(UIView *subview in [[[[[[nowPlayingHeaderView superview] superview] superview] superview] superview] subviews])
			{
				if([subview isKindOfClass: %c(MTMaterialView)])
				{
					[subview setClipsToBounds: YES];
					[[subview layer] setCornerRadius: [preferences lockScreenMusicWidgetCornerRadius]];
					[[subview layer] setMaskedCorners: cornerMask];

					if([preferences addLockScreenMusicWidgetBorder])
						[[subview layer] setBorderWidth: [preferences lockScreenMusicWidgetBorderWidth]];

					[UIView animateWithDuration: [colorizer backgroundColorChangeDuration] animations:
					^{
						[subview setBackgroundColor: [colorizer backgroundColor]];
						if([preferences addLockScreenMusicWidgetBorder])
							[[subview layer] setBorderColor: [colorizer primaryColor].CGColor];
					}
					completion: nil];

					break;
				}
			}
		}
		else if([preferences colorizeControlCenterMusicWidget] && [[[[[[nowPlayingHeaderView superview] superview] superview] superview] superview] isKindOfClass: %c(CCUIContentModuleContentContainerView)])
		{
			[nowPlayingHeaderView colorize];
			[[self routingCornerView] colorize];
			[[[[self parentContainerView] containerView] timeControl] colorize];
			[[[[self parentContainerView] containerView] transportStackView] colorize];
			[[[self volumeContainerView] volumeSlider] colorize];

			if([self backgroundView] && [[self backgroundView] isKindOfClass: %c(MediaControlsMaterialView)])
			{
				if([[[self backgroundView] subviews] count] > 0 && [[[self backgroundView] subviews][0] isKindOfClass: %c(MTMaterialView)])
				{
					MTMaterialView *materialView = (MTMaterialView*)[[self backgroundView] subviews][0];
					SBMediaController *media = [%c(SBMediaController) sharedInstance];
					if(media && [media nowPlayingApplication])
					{
						[[materialView layer] setFilters: 0];
						[materialView setRecipe: 8];

						if([preferences addControlCenterWidgetBorder])
							[[materialView layer] setBorderWidth: 3.0f];
						
						[UIView animateWithDuration: [colorizer backgroundColorChangeDuration] animations:
						^{
							[materialView setBackgroundColor: [colorizer backgroundColor]];
							if([preferences addControlCenterWidgetBorder])
								[[materialView layer] setBorderColor: [colorizer primaryColor].CGColor];
						}
						completion: nil];
					}
				}
			}
		}
	}

	- (void)viewDidLayoutSubviews
	{
		%orig;

		if([preferences colorizeControlCenterMusicWidget] && [preferences addControlCenterWidgetBorder])
		{
			if([self backgroundView] && [[self backgroundView] isKindOfClass: %c(MediaControlsMaterialView)])
			{
				if([[[self backgroundView] subviews] count] > 0 && [[[self backgroundView] subviews][0] isKindOfClass: %c(MTMaterialView)])
				{
					MTMaterialView *materialView = (MTMaterialView*)[[self backgroundView] subviews][0];
					
					float cornerRadius = [[[[[[[materialView superview] superview] superview] superview] superview] layer] cornerRadius];
					if(cornerRadius == 0)
						cornerRadius = 19;
					
					[[materialView layer] setCornerRadius: cornerRadius];	
				}
			}
		}
	}

	%end

	%hook MediaControlsHeaderView

	- (id)initWithFrame: (CGRect)arg1
	{
		self = %orig;
		if([self isKindOfClass: %c(NextUpMediaHeaderView)])
			[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(colorize) name: @"MusicArtworkChanged" object: nil];
		else
			[[self artworkView] addObserver: self forKeyPath: @"image" options: NSKeyValueObservingOptionNew context: nil];
		return self;
	}

	%new
	- (void)observeValueForKeyPath: (NSString*)keyPath ofObject: (id)object change: (NSDictionary<NSKeyValueChangeKey, id>*)change context: (void*)context
	{
		if([[self _viewControllerForAncestor] isKindOfClass: %c(MRPlatterViewController)] && [[[self artworkView] image] isKindOfClass: %c(UIImage)])
		{
			UIImage *image = [[self artworkView] image];
			if(image && [image size].width > 0)
			{
				MRPlatterViewController *controller = [self _viewControllerForAncestor];
				
				if([controller isOnScreen])
					[colorizer generateColorsForArtwork: [[self artworkView] image] withTitle: [[self primaryLabel] text]];
				
				if([[self primaryLabel] textColor] != [colorizer primaryColor]) 
					[controller colorize];
			}
		}
	}

	%new
	- (void)colorize
	{
		colorizeUILabel([[self routeLabel] titleLabel], [colorizer secondaryColor], [self visualStylingProvider]);
		
		[[self primaryLabel] setCustomTextColor: [colorizer primaryColor]];
		colorizeUILabel([self primaryLabel], [colorizer primaryColor], [self visualStylingProvider]);
		
		[[self secondaryLabel] setCustomTextColor: [colorizer secondaryColor]];
		colorizeUILabel([self secondaryLabel], [colorizer secondaryColor], [self visualStylingProvider]);
		
		[[self shadow] setHidden: YES];
		[[self artworkBackground] setHidden: YES];
		
		if(![self isKindOfClass: %c(NextUpMediaHeaderView)]) [[self routingButton] colorize];
		else
		{
			for(UIView *view in [[self superview] subviews])
			{
				if([view isKindOfClass: %c(UILabel)]) 
				{
					[((UILabel*)view) setTextColor: [colorizer primaryColor]];
					break;
				}
			}
			[[self routingButton] setBackgroundColor: [colorizer primaryColor]];
			for(CALayer *sublayer in [[[self routingButton] layer] sublayers])
			{
				if([sublayer isKindOfClass: %c(CAShapeLayer)])
				{
					CAShapeLayer *caShapeSublayer = (CAShapeLayer*)sublayer;
					[caShapeSublayer setCustomStrokeColor: [colorizer backgroundColor]];
					[caShapeSublayer setStrokeColor: [colorizer backgroundColor].CGColor];
				}
			}

		}
	}

	%end

	%hook MediaControlsVolumeSlider

	%new
	- (void)colorize
	{
		colorizeUIView([self _minTrackView], nil, nil, [self visualStylingProvider]);
		colorizeUIView([self _maxTrackView], nil, nil, [self visualStylingProvider]);
		colorizeUIView([self _minValueView], nil, [colorizer secondaryColor], nil);
		colorizeUIView([self _maxValueView], nil, [colorizer secondaryColor], nil);
		[self setMinimumTrackTintColor: [colorizer primaryColor]];
		[self setMaximumTrackTintColor: [colorizer secondaryColor]];
		
		if([self isKindOfClass: %c(MediaControlsMasterVolumeSlider)])
			[MSHookIvar<UIView*>(self, "_growingThumbView") setBackgroundColor: [colorizer primaryColor]];
		else
		{
			UIImageView *thumbView = MSHookIvar<UIImageView*>(self, "_thumbView");
			if([[self thumbImageForState: UIControlStateNormal] renderingMode] != UIImageRenderingModeAlwaysTemplate)
				[self setThumbImage: [[self thumbImageForState: UIControlStateNormal] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateNormal];
			colorizeUIView(thumbView, nil, [colorizer primaryColor], nil);
			[[thumbView layer] setShadowColor: [colorizer primaryColor].CGColor];
		}
	}

	%end

	%hook MediaControlsTimeControl

	%new
	- (void)colorize
	{
		colorizeUIView([self elapsedTrack], [colorizer primaryColor], nil, [self visualStylingProvider]);
		colorizeUIView([self remainingTrack], [colorizer secondaryColor], nil, [self visualStylingProvider]);
		colorizeUIView([self knobView], [colorizer primaryColor], nil, nil);
		colorizeUIView([self liveBackground], [colorizer secondaryColor], nil, nil);
		colorizeUILabel([self elapsedTimeLabel], [colorizer primaryColor], [self visualStylingProvider]);
		colorizeUILabel([self remainingTimeLabel], [colorizer primaryColor], [self visualStylingProvider]);
		colorizeUILabel([self liveLabel], [colorizer secondaryColor], [self visualStylingProvider]);
	}

	%end

	// COLORIZE THE SMALL ROUTING BUTTON IN THE CORNER OF CONTROL CENTER MUSIC WIDGET

	%hook MediaControlsRoutingCornerView

	%new
	- (void)colorize
	{
		for(CALayer *sublayer1 in [MSHookIvar<CALayer*>(self, "_packageLayer") sublayers])
		{
			for(CALayer *sublayer2 in [sublayer1 sublayers])
			{
				[(CAShapeLayer*)sublayer2 setFillColor: [colorizer primaryColor].CGColor];
				[sublayer2 setOpacity: 1];
				[sublayer2 setCompositingFilter: nil];
			}
		}
	}

	%end

	// COLORIZE THE ROUTING BUTTON ON TOP RIGHT OF LOCK SCREEN'S MUSIC WIDGET

	%hook MediaControlsRoutingButtonView

	%new
	- (void)colorize
	{
		for(CALayer *sublayer1 in [MSHookIvar<CALayer*>([self packageView], "_packageLayer") sublayers])
		{
			[sublayer1 setBackgroundColor: [colorizer primaryColor].CGColor];
			[sublayer1 setCornerRadius: 18];

			for(CALayer *sublayer2 in [sublayer1 sublayers])
			{
				for(CALayer *sublayer3 in [sublayer2 sublayers])
				{
					[(CAShapeLayer*)sublayer3 setFillColor: [colorizer backgroundColor].CGColor];
					[sublayer3 setOpacity: 1];
					[sublayer3 setCompositingFilter: nil];
				}
			}
		}
	}

	%end

	//------------ STOP VOLUME SLIDER FROM RESETING IT'S COLOR ------------

	%hook MediaControlsVolumeSlider

	- (void)tintColorDidChange
	{
		
	}

	%end

	//------------ COLORIZE PREVIOUS PLAY AND NEXT BUTTONS ------------

	%hook MediaControlsTransportStackView

	- (void)_updateButtonVisualStyling: (id)arg1
	{
		if([colorizer primaryColor]) [self colorize];
		else 
			%orig;
	}

	%new
	- (void)colorize
	{
		if([colorizer primaryColor])
		{
			[[[self leftButton] imageView] setCustomTintColor: [colorizer primaryColor]];
			colorizeUIView([[self leftButton] imageView], nil, [colorizer primaryColor], nil);
			[[[self middleButton] imageView] setCustomTintColor: [colorizer primaryColor]];
			colorizeUIView([[self middleButton] imageView], nil, [colorizer primaryColor], nil);
			[[[self rightButton] imageView] setCustomTintColor: [colorizer primaryColor]];
			colorizeUIView([[self rightButton] imageView], nil, [colorizer primaryColor], nil);
			
			if([preferences showExtraButtons])
			{
				colorizeUIView([[self shuffleButton] imageView], nil, [colorizer primaryColor], nil);
				colorizeUIView([[self repeatButton] imageView], nil, [colorizer primaryColor], nil);
			}
		}
		else
		{
			[self _updateButtonVisualStyling: [self leftButton]];
			[self _updateButtonVisualStyling: [self middleButton]];
			[self _updateButtonVisualStyling: [self rightButton]];
		}
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

void initMusicWidget()
{
	@autoreleasepool
	{
		preferences = [MusicPreferences sharedInstance];
		colorizer = [Colorizer sharedInstance];
		
		if(![preferences disableTopLeftCornerRadius])
			cornerMask += kCALayerMinXMinYCorner;
		if(![preferences disableTopRightCornerRadius])
			cornerMask += kCALayerMaxXMinYCorner;
		if(![preferences disableBottomLeftCornerRadius])
			cornerMask += kCALayerMinXMaxYCorner;
		if(![preferences disableBottomRightCornerRadius])
			cornerMask += kCALayerMaxXMaxYCorner;

		if([preferences colorizeLockScreenMusicWidget] || [preferences colorizeControlCenterMusicWidget])
			%init(colorizeWidgetGroup);

		if([preferences vibrateMusicWidget] && ![preferences isIpad])
			%init(vibrateMusicWidgetGroup);
	}
}