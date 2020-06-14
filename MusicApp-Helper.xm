#import "MusicPreferences.h"
#import "MusicApp.h"
#import "Colorizer.h"

static MusicPreferences *preferences;

static UIColor *customNowPlayingViewTintColor;
static UIColor *systemBackgroundColor;

%hook MPVolumeSlider

- (void)setMinimumTrackTintColor: (UIColor*)arg
{
	UIColor *color = [self customMinimumTrackTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customMinimumTrackTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customMinimumTrackTintColor));
}

%new
- (void)setCustomMinimumTrackTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customMinimumTrackTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMaximumTrackTintColor: (UIColor*)arg
{
	UIColor *color = [self customMaximumTrackTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customMaximumTrackTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customMaximumTrackTintColor));
}

%new
- (void)setCustomMaximumTrackTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customMaximumTrackTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook MPButton

- (void)touchesEnded: (id)arg1 withEvent: (id)arg2
{
	%orig;
    if([self specialButton])
	{
		if([preferences colorizeMusicApp])
			[self updateButtonColor];
		else if([preferences enableMusicAppNowPlayingViewCustomTint])
			[self setCustomButtonTintColorWithBackgroundColor: systemBackgroundColor];
	}
}

- (void)setSelected: (BOOL)arg
{
	%orig;
	if([self specialButton])
	{
		if([preferences colorizeMusicApp])
			[self updateButtonColor];
		else if([preferences enableMusicAppNowPlayingViewCustomTint])
			[self setCustomButtonTintColorWithBackgroundColor: systemBackgroundColor];
	}
}

%new
- (void)updateButtonColor
{
	[[self layer] setCornerRadius: 7];

	id type = [self specialButton]; // type 1 == lyrics button, type 2 == queue button, type 3 == queue header buttons

	if(![type isEqual: @2])
		[[self imageView] setImage: [[[self imageView] image] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate]];
	else
		[self setImage: [[[self imageView] image] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateSelected];
	
	Colorizer *colorizer = [Colorizer sharedInstance];

	if([self isSelected])
	{
		if([type isEqual: @1])
		{
			[self setCustomTintColor: [colorizer secondaryColor]];
			[self setTintColor: [colorizer secondaryColor]];
			[self setCustomBackgroundColor: [colorizer backgroundColor]];
			[self setBackgroundColor: [colorizer backgroundColor]];
		}
		else
		{
			[self setCustomTintColor: [colorizer backgroundColor]];
			[self setTintColor: [colorizer backgroundColor]];
			[self setCustomBackgroundColor: [colorizer secondaryColor]];
			[self setBackgroundColor: [colorizer secondaryColor]];
		}
	}
	else
	{
		[self setCustomTintColor: [colorizer secondaryColor]];
		[self setTintColor: [colorizer secondaryColor]];
		[self setCustomBackgroundColor: [UIColor clearColor]];
		[self setBackgroundColor: [UIColor clearColor]];
	}
}

%new
- (void)setCustomButtonTintColorWithBackgroundColor: (UIColor*)bgColor
{
	systemBackgroundColor = bgColor;

	[[self layer] setCornerRadius: 7];

	id type = [self specialButton]; // type 1 == lyrics button, type 2 == queue button, type 3 == queue header buttons

	if(![type isEqual: @2])
		[[self imageView] setImage: [[[self imageView] image] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate]];
	else
		[self setImage: [[[self imageView] image] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateSelected];
	
	if([self isSelected])
	{
		if([type isEqual: @1])
		{
			[self setCustomTintColor: customNowPlayingViewTintColor];
			[self setTintColor: customNowPlayingViewTintColor];
			[self setCustomBackgroundColor: [UIColor clearColor]];
			[self setBackgroundColor: [UIColor clearColor]];
		}
		else
		{
			[self setCustomTintColor: systemBackgroundColor];
			[self setTintColor: systemBackgroundColor];
			[self setCustomBackgroundColor: customNowPlayingViewTintColor];
			[self setBackgroundColor: customNowPlayingViewTintColor];
		}
	}
	else
	{
		[self setCustomTintColor: customNowPlayingViewTintColor];
		[self setTintColor: customNowPlayingViewTintColor];
		[self setCustomBackgroundColor: [UIColor clearColor]];
		[self setBackgroundColor: [UIColor clearColor]];
	}
}

%new
- (id)specialButton
{
	return (id)objc_getAssociatedObject(self, @selector(specialButton));
}

%new
- (void)setSpecialButton: (id)type
{
	objc_setAssociatedObject(self, @selector(specialButton), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook UIView

- (void)setBackgroundColor: (UIColor*)arg
{
	UIColor *color = [self customBackgroundColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customBackgroundColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customBackgroundColor));
}

%new
- (void)setCustomBackgroundColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customBackgroundColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTintColor: (UIColor*)arg
{
	UIColor *color = [self customTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTintColor));
}

%new
- (void)setCustomTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook UILabel

- (void)setTextColor: (UIColor *)arg1
{
	UIColor *color = [self customTextColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTextColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTextColor));
}

%new
- (void)setCustomTextColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTextColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAttributedText: (NSAttributedString*)arg1
{
	NSMutableAttributedString *s = [arg1 mutableCopy];
	[s removeAttribute: NSForegroundColorAttributeName range: NSMakeRange(0, [s length])];
	%orig([s copy]);
}

%end

%hook UIImageView

- (void)setTintColor: (UIColor*)arg
{
	UIColor *color = [self customTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTintColor));
}

%new
- (void)setCustomTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook MPRouteButton

- (void)setTintColor: (UIColor*)arg
{
	UIColor *color = [self customTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTintColor));
}

%new
- (void)setCustomTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook MPRouteLabel

- (void)setTextColor: (UIColor *)arg1
{
	UIColor *color = [self customTextColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTextColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTextColor));
}

%new
- (void)setCustomTextColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTextColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook UIButton

- (void)setBackgroundColor: (UIColor*)arg
{
	UIColor *color = [self customBackgroundColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customBackgroundColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customBackgroundColor));
}

%new
- (void)setCustomBackgroundColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customBackgroundColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTitleColor: (UIColor*)arg1 forState: (unsigned long long)arg2
{
	UIColor *color = [self customTitleColor];
	if(color) %orig(color, arg2);
	else %orig;
}

- (void)setTitleColor: (UIColor*)arg1 forStates: (unsigned long long)arg2
{
	UIColor *color = [self customTitleColor];
	if(color) %orig(color, arg2);
	else %orig;
}

- (void)_setTitleColor: (UIColor*)arg1 forStates: (unsigned long long)arg2
{
	UIColor *color = [self customTitleColor];
	if(color) %orig(color, arg2);
	else %orig;
}

%new
- (UIColor*)customTitleColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTitleColor));
}

%new
- (void)setCustomTitleColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTitleColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTintColor: (UIColor*)arg
{
	UIColor *color = [self customTintColor];
	if(color) %orig(color);
	else %orig;
}

%new
- (UIColor*)customTintColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customTintColor));
}

%new
- (void)setCustomTintColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customTintColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

void initMusicAppHelper()
{
	preferences = [MusicPreferences sharedInstance];
	if([preferences enableMusicAppNowPlayingViewCustomTint])
		customNowPlayingViewTintColor = [preferences customMusicAppNowPlayingViewTintColor];

	%init;
}