#import "VolumeControl.h"
#import "MusicPreferences.h"

static const float VOLUME_STEP =  1.0 / 16.0;

static MPCMediaRemoteController *mediaRemoteController;

static MusicPreferences *preferences;
static BOOL volumeControl;
static BOOL swapButtons;

static BOOL upPressed = NO;
static BOOL downPressed = NO;
static BOOL shouldScreenshot = NO;

static NSTimer *forwardTimer;
static NSTimer *backTimer;

// Used code by @gilshahar7: https://github.com/gilshahar7/VolumeSongSkipper113

%hook MPCMediaRemoteController

-(id)_init
{
    mediaRemoteController = %orig;
    return mediaRemoteController;
}

%end

%hook SpringBoard

- (BOOL)_handlePhysicalButtonEvent: (UIPressesEvent*)pressesEvent
{
    if([[[self _accessibilityFrontMostApplication] bundleIdentifier] isEqualToString: @"com.apple.camera"])
        return %orig;

    BOOL hasUp = NO;
    BOOL hasDown = NO;
    BOOL hasLock = NO;

    for(UIPress* press in [[pressesEvent allPresses] allObjects])
    {
        if([press type] == 102 && [press force] == 1)
            hasUp = YES;
        if([press type] == 103 && [press force] == 1)
            hasDown = YES;
        if([press type] == 104 && [press force] == 1)
            hasLock = YES;
    }

    if(hasUp && hasDown) 
    {
        if(volumeControl)
            [mediaRemoteController sendCommand: 2 options: nil completion: ^{}];
        return NO;
    }

    if(hasUp && hasLock)
    {
        shouldScreenshot = true;
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
            if(shouldScreenshot)
            {
                [self takeScreenshot];
                shouldScreenshot = false;
            }
            else
            {
                float volume;
                [[%c(AVSystemController) sharedAVSystemController] getActiveCategoryVolume: &volume andName: nil];

                if(swapButtons && [[UIApplication sharedApplication] _frontMostAppOrientation] == UIDeviceOrientationLandscapeLeft)
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

            if(swapButtons && [[UIApplication sharedApplication] _frontMostAppOrientation] == UIDeviceOrientationLandscapeLeft)
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
    if(upPressed)
    {
        if(volumeControl)
            [mediaRemoteController sendCommand: 4 options: nil completion: ^{}];
        upPressed = NO;
    }
}

%new
- (void)goBackward
{
    if(downPressed)
    {
        if(volumeControl)
            [mediaRemoteController sendCommand: 5 options: nil completion: ^{}];
        downPressed = NO;
    }
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