#import "MediaRemote.h"
#import "VolumeControl.h"
#import "MusicPreferences.h"

static const float VOLUME_STEP =  1.0 / 16.0;

static BOOL upPressed = NO;
static BOOL downPressed = NO;

static NSTimer *forwardTimer;
static NSTimer *backTimer;

static BOOL shouldSwap = NO;

static void produceMediumVibration()
{
	UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
	[gen prepare];
	[gen impactOccurred];
}

// Used code by @gilshahar7: https://github.com/gilshahar7/VolumeSongSkipper113

%group controlMediaWithVolumeButtonsGroup

	%hook SpringBoard

	- (BOOL)_handlePhysicalButtonEvent: (UIPressesEvent*)pressesEvent
	{
		if([[[self _accessibilityFrontMostApplication] bundleIdentifier] isEqualToString: @"com.apple.camera"])
			return %orig;

		BOOL hasUp = NO;
		CGFloat upForce;
		BOOL hasDown = NO;
		CGFloat downForce;
		
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
		}

		if(hasUp && hasDown) 
		{
			if(upForce == 1 && downForce == 1)
			{
				MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
				produceMediumVibration();
			}
		}
		else if(hasUp || hasDown)
		{
			UIPress *press = [[pressesEvent allPresses] allObjects][0];
			long pressType = [press type];
			CGFloat pressForce = [press force];

			if(pressType == 102 && pressForce == 1) //VOLUME UP PRESSED
			{
				upPressed = YES;
				forwardTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(goForward) userInfo: nil repeats: NO];
				if(backTimer != nil)
				{
					[backTimer invalidate];
					backTimer = nil;
				}
			}

			if(pressType == 103 && pressForce == 1) //VOLUME DOWN PRESSED
			{
				downPressed = YES;
				backTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(goBackward) userInfo: nil repeats: NO];
				if(forwardTimer != nil)
				{
					[forwardTimer invalidate];
					forwardTimer = nil;
				}
			}

			if(pressType == 102 && pressForce == 0) //VOLUME UP RELEASED
			{
				upPressed = NO;
				if(forwardTimer != nil)
				{
					[forwardTimer invalidate];
					forwardTimer = nil;
				}
			}

			if(pressType == 103 && pressForce == 0) //VOLUME DOWN RELEASED
			{
				downPressed = NO;
				if(backTimer != nil)
				{
					[backTimer invalidate];
					backTimer = nil;
				}
			}
		}
		return %orig;
	}

	%new
	- (void)goForward
	{
		if(upPressed)
		{
			MRMediaRemoteSendCommand(kMRNextTrack, nil);
			produceMediumVibration();	
		}
		upPressed = NO;
	}

	%new
	- (void)goBackward
	{
		if(downPressed)
		{
			MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
			produceMediumVibration();
		}
		downPressed = NO;
	}

	%end

%end

%group swapVolumeButtonsGroup

	%hook SBVolumeControl

	- (BOOL)_isVolumeHUDVisibleOrFading
	{
		UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
		if (deviceOrientation == UIDeviceOrientationLandscapeLeft
		|| deviceOrientation == UIDeviceOrientationPortraitUpsideDown
		|| deviceOrientation == UIDeviceOrientationFaceUp && shouldSwap
		|| deviceOrientation == UIDeviceOrientationFaceDown && shouldSwap)
			shouldSwap = YES;
		else
			shouldSwap = NO;

		return %orig;
	}

	%end

%end

%group volumeControlGeneralGroup

	%hook SBVolumeControl

	- (void)increaseVolume
	{
		if(!forwardTimer)
		{
			if(shouldSwap)
				[self changeVolumeByDelta: -VOLUME_STEP];
			else
				%orig;
		}
	}

	- (void)decreaseVolume
	{
		if(!backTimer)
		{
			if(shouldSwap)
				[self changeVolumeByDelta: VOLUME_STEP];
			else
				%orig;
		}
	}

	%end

%end

void initVolumeControl()
{
	MusicPreferences *preferences = [MusicPreferences sharedInstance];

	if([preferences enabledMediaControlWithVolumeButtons] || [preferences swapVolumeButtonsBasedOnOrientation])
	{
		%init(volumeControlGeneralGroup);

		if([preferences enabledMediaControlWithVolumeButtons])
			%init(controlMediaWithVolumeButtonsGroup);

		if([preferences swapVolumeButtonsBasedOnOrientation])
			%init(swapVolumeButtonsGroup);
	}
}