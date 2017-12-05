#import "RNPlayAudio.h"

#import "RCTEventDispatcher.h"

#if __has_include("RCTUtils.h")
    #import "RCTUtils.h"
#else
    #import <React/RCTUtils.h>
#endif
#import <AVFoundation/AVFoundation.h>

@implementation RNPlayAudio {
	AVPlayer *player;
	RCTResponseSenderBlock onEnd;
	RCTResponseSenderBlock onReady;
    int observerContext;
}

- (RNPlayAudio *)init
{
   self = [super init];
   if (self) {
      observerContext = 0;
   }
   
   return self;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (void) playerDidFinishPlaying:(NSNotification *) note {
    if (onEnd) {
        onEnd(@[]);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (context != &observerContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        // Get the status change from the change dictionary
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        // Switch over the status
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                if (onReady) {
                    onReady(@[]);
                    onReady = nil;
                }
                break;
            case AVPlayerItemStatusFailed:
                // Failed. Examine AVPlayerItem.error
                break;
            case AVPlayerItemStatusUnknown:
                // Not ready
                break;
        }
    }
}

- (void) addObservers:(AVPlayerItem *) playerItem {
    [playerItem addObserver:self
             forKeyPath:@"status"
                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                context:&observerContext];

    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
        selector:@selector(playerDidFinishPlaying:) 
        name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem
    ];
}

- (void) removeObservers:(AVPlayerItem *) playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    if (player) {
        [self removeObservers:[player currentItem]];
        player = nil;
    }
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(prepare:(NSString*)url: (RCTResponseSenderBlock)callback) {
    NSURL *nsurl = [NSURL URLWithString:url]; 

    AVAsset *asset = [AVAsset assetWithURL:nsurl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];

    if (player) {
        [self removeObservers:[player currentItem]];
        [player replaceCurrentItemWithPlayerItem:playerItem];
    } else {
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    onReady = callback;
    [self addObservers:[player currentItem]];
}

RCT_EXPORT_METHOD(play) {
	if (player) {
  		[player play];
	}
}

RCT_EXPORT_METHOD(stop) {
	if (player) {
		[player pause];
		player = nil;
	}
}
RCT_EXPORT_METHOD(pause) {
	if (player) {
  		[player pause];
	}
}
RCT_EXPORT_METHOD(onEnd: (RCTResponseSenderBlock)callback) {
	onEnd = callback;
}
RCT_EXPORT_METHOD(setTime: (nonnull NSNumber *)seconds) {
    if (player) {
        [player seekToTime: CMTimeMakeWithSeconds([seconds floatValue], NSEC_PER_SEC)];
    }
}
RCT_EXPORT_METHOD(getCurrentTime: (RCTResponseSenderBlock)callback) {
    if (player) {
        Float64 currentTime = CMTimeGetSeconds([player currentTime]);
        callback(@[@(currentTime)]);
    }
}
RCT_EXPORT_METHOD(getDuration: (RCTResponseSenderBlock)callback) {
    if (player) {
        Float64 dur = CMTimeGetSeconds([[player currentItem] duration]);
        callback(@[@(dur)]);
    }
}
@end
  
