#import "MediaRemote.h"
#import "VolumeControl.h"
#import "MusicPreferences.h"

static const float VOLUME_STEP =  1.0 / 16.0;

static MusicPreferences *preferences;
static BOOL volumeControl;
static BOOL swapButtons;

static BOOL upPressed = NO;
static BOOL downPressed = NO;

static NSTimer *forwardTimer;
static NSTimer *backTimer;

static void produceMediumVibration()
{
	UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
	[gen prepare];
	[gen impactOccurred];
}

// Used code by @gilshahar7: https://github.com/gilshahar7/VolumeSongSkipper113

%hook SpringBoard

- (BOOL)_handlePhysicalButtonEvent: (UIPressesEvent*)pressesEvent
{
	if([[[self _accessibilityFrontMostApplication] bundleIdentifier] isEqualToString: @"com.apple.camera"])
		return %orig;

	BOOL hasUp = NO;
	int upForce;
	BOOL hasDown = NO;
	int downForce;
	BOOL hasLock = NO;

	for(UIPress* press in [[pressesEvent allPresses] allObjects])
	{
		if([press type] == 102)
		{
			hasUp = YES;
			upForce = [press force];
		}
		if([press type] == 103)
		{
			hasDown = YES;
			downForce = [press force];
		}
		if([press type] == 104)
			hasLock = YES;
	}

	if(hasLock)
		return %orig;
	else if(volumeControl && hasUp && hasDown && upForce == 1 && downForce == 1) 
	{
		MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
		produceMediumVibration();
		return NO;
	}

	UIPress *press = [[pressesEvent allPresses] allObjects][0];
	int pressType = [press type];
	int pressForce = [press force];

	if(pressType == 102 && pressForce == 1) //VOLUME UP PRESSED
	{
		upPressed = YES;
		forwardTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(goForward) userInfo: nil repeats: NO];
		if(backTimer != nil)
		{
			[backTimer invalidate];
			backTimer = nil;
		}
	}

	if(pressType == 103 && pressForce == 1) //VOLUME DOWN PRESSED
	{
		downPressed = YES;
		backTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(goBackward) userInfo: nil repeats: NO];
		if(forwardTimer != nil)
		{
			[forwardTimer invalidate];
			forwardTimer = nil;
		}
	}

	if(pressType == 102 && pressForce == 0) //VOLUME UP RELEASED
	{	
		if(upPressed)
		{
			float volume;
			[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume: &volume andName: nil];

			if(swapButtons && [self _frontMostAppOrientation] == UIDeviceOrientationLandscapeLeft)
			{
				volume -= VOLUME_STEP;
				if(volume < 0)
					volume = 0;
			}
			else
			{
				volume += VOLUME_STEP;
				if(volume > 1)
					volume = 1;
			}
			
			[[%c(AVSystemController) sharedAVSystemController] setActiveCategoryVolumeTo: volume];
		}
		upPressed = NO;
		if(forwardTimer != nil)
		{
			[forwardTimer invalidate];
			forwardTimer = nil;
		}
	}

	if(pressType == 103 && pressForce == 0) //VOLUME DOWN RELEASED
	{
		if(downPressed)
		{
			float volume;
			[[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume: &volume andName: nil];

			if(swapButtons && [self _frontMostAppOrientation] == UIDeviceOrientationLandscapeLeft)
			{
				volume += VOLUME_STEP;
				if(volume > 1)
					volume = 1;
			}
			else
			{
				volume -= VOLUME_STEP;
				if(volume < 0)
					volume = 0;
			}
			
			[[%c(AVSystemController) sharedAVSystemController] setActiveCategoryVolumeTo: volume];
		}
		downPressed = NO;
		if(backTimer != nil)
		{
			[backTimer invalidate];
			backTimer = nil;
		}
	}

	if(pressType == 102 || pressType == 103) 
		return NO;
	else
		return %orig;
}

%new
- (void)goForward
{
	if(upPressed && volumeControl)
	{
		MRMediaRemoteSendCommand(kMRNextTrack, nil);
		produceMediumVibration();	
	}
	upPressed = NO;
}

%new
- (void)goBackward
{
	if(downPressed && volumeControl)
	{
		MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
		produceMediumVibration();
	}
	downPressed = NO;
}

%end

void initVolumeControl()
{
	@autoreleasepool
	{
		preferences = [MusicPreferences sharedInstance];
		volumeControl = [preferences enabledMediaControlWithVolumeButtons];
		swapButtons = [preferences swapVolumeButtonsOnLandscapeLeft];

		if(volumeControl || swapButtons)
			%init;
	}
}