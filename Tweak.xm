//
//  Tweak.xm
//  Erie
//
//  Created by Janik Schmidt on 14.07.19.
//

#import "Tweak.h"

void triggerHapticFeedback(BOOL buttonDown) {
	if (prominentHaptics && buttonDown) {
		[[[UIDevice currentDevice] _tapticEngine] prepareUsingFeedback:1];
		[[[UIDevice currentDevice] _tapticEngine] actuateFeedback:1];
	} else {
		[[[UIDevice currentDevice] _tapticEngine] prepareUsingFeedback:0];
		[[[UIDevice currentDevice] _tapticEngine] actuateFeedback:0];
	}
}



%hook UIApplication
- (void)sendEvent:(id)arg1 {
	if ([arg1 isKindOfClass:%c(UIPressesEvent)]) {
		NSArray* presses = [[(UIPressesEvent*)arg1 _allPresses] allObjects];
		NSMutableArray* usablePresses = [NSMutableArray new];
		
		for (id press in presses) {
			if ([press isKindOfClass:%c(UIPress)]) {
				[usablePresses addObject:press];
			}
		}
		
		usablePresses = [[usablePresses sortedArrayUsingComparator:^NSComparisonResult(UIPress* press1, UIPress* press2) {
			return [[NSNumber numberWithLongLong:press1.type] compare:[NSNumber numberWithLongLong:press2.type]];
		}] mutableCopy];
		
		
		
		UIPress* press = [usablePresses firstObject];
		BOOL buttonDown = (press.phase == 0);
		
		switch (press.type) {
			// Home Button pressed
			case 101:
				if (homeButtonHaptics) {
					triggerHapticFeedback(buttonDown);
				}
				break;
			
			// Volume Up/Down pressed
			case 102:
			case 103:
				if (volumeButtonHaptics) {
					triggerHapticFeedback(buttonDown);
				}
				break;
			
			// Side Button pressed
			case 104:
				if (lockButtonHaptics) {
					triggerHapticFeedback(buttonDown);
				}
				break;
				
			// Touch ID touched
			case 105:
				if (mesaHaptics) {
					triggerHapticFeedback(buttonDown);
				}
				break;
			default: break;
		}
	}
	
	%orig;
}
%end	// %hook UIApplication



%ctor {
	// File integrity check
	if (access(DPKG_PATH, F_OK) == -1) {
		NSLog(@"[Erie] You are using Erie from a source other than https://repo.festival.ml");
		NSLog(@"[Erie] To ensure system stability and security (or what's left of it, thanks to your jailbreak), Erie will disable itself now.");
		
		return;
	}
	
	eriePreferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/ml.festival.erie.plist"];
	
	enabled = (BOOL)[[eriePreferences objectForKey:@"enabled"] ?: @YES boolValue];
	homeButtonHaptics = (BOOL)[[eriePreferences objectForKey:@"homeButtonHaptics"] ?: @YES boolValue];
	lockButtonHaptics = (BOOL)[[eriePreferences objectForKey:@"lockButtonHaptics"] ?: @NO boolValue];
	volumeButtonHaptics = (BOOL)[[eriePreferences objectForKey:@"volumeButtonHaptics"] ?: @NO boolValue];
	mesaHaptics = (BOOL)[[eriePreferences objectForKey:@"mesaHaptics"] ?: @NO boolValue];
	prominentHaptics = (BOOL)[[eriePreferences objectForKey:@"prominentHaptics"] ?: @YES boolValue];
	
	if (enabled) {
		%init;
	}
}
