
#if __has_include(<React/RCTBridgeModule.h>)
    #import <React/RCTBridgeModule.h>
#else
    #import "RCTBridgeModule.h"
#endif

#import <AVFoundation/AVFoundation.h>

@interface RNPlayAudio : NSObject <RCTBridgeModule>

@end
