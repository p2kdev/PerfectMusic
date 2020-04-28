#import "MusicSpringboard.h"

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

%end

%hook CAShapeLayer

- (void)setStrokeColor: (CGColorRef)arg1
{
	UIColor *color = [self customStrokeColor];
	if(color) %orig(color.CGColor);
	else %orig;
}

%new
- (UIColor*)customStrokeColor
{
	return (UIColor*)objc_getAssociatedObject(self, @selector(customStrokeColor));
}

%new
- (void)setCustomStrokeColor: (UIColor*)arg
{
	objc_setAssociatedObject(self, @selector(customStrokeColor), arg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

void initMusicWidgetHelper()
{
	%init;
}