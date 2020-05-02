#import "MusicPreferences.h"

extern void initVolumeControl();
extern void initMusicWidgetHelper();
extern void initMusicWidget();
extern void initMusicApp();
extern void initMusicAppHelper();

%ctor
{
    @autoreleasepool
	{
		if([[MusicPreferences sharedInstance] enabled])
        {
            NSString *processName = [NSProcessInfo processInfo].processName;
            bool isSpringboard = [@"SpringBoard" isEqualToString: processName];
            bool isMusicApp = [@"Music" isEqualToString: processName];

            if(isSpringboard) 
            {
                initVolumeControl();
                initMusicWidgetHelper();
                initMusicWidget();
            }
            if(isMusicApp)
            {
                initMusicAppHelper();
                initMusicApp();
            }
        }
    }
}