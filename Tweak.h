//
//  Tweak.h
//  Erie
//
//  Created by Janik Schmidt on 14.07.19.
//

#define DPKG_PATH "/var/lib/dpkg/info/ml.festival.erie.list"

/**
 * Headers
 */

@interface UIDevice (Private)
+ (id)currentDevice;
- (id)_tapticEngine;
@end

@interface _UITapticEngine : NSObject
- (void)actuateFeedback:(long long)arg1 ;
- (void)prepareUsingFeedback:(long long)arg1 ;
@end

@interface UIPressesEvent (Private)
- (id)_allPresses;
@end

@interface UIPress (Private)
- (long long)type;
- (long long)phase;
@end



/**
 * Preferences
 */
static NSDictionary* eriePreferences;

static BOOL enabled;
static BOOL homeButtonHaptics;
static BOOL lockButtonHaptics;
static BOOL volumeButtonHaptics;
static BOOL mesaHaptics;
static BOOL prominentHaptics;
