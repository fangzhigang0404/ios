//
//  MPAudioMessagePlayer.h
//  MarketPlace
//
//  Created by Arnav Jain on 18/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPAudioManagerDelegate <NSObject>

@optional
- (void)audioDidEndPlaying:(BOOL)successfully;
- (void)audioDidEndRecording:(BOOL)successfully;
- (void)audioDidStartPlaying:(BOOL)successfully;
- (void)audioDidStartRecording:(BOOL)successfully;
- (void)audioInterruptionBegan;
- (void)audioInterruptionEnded;
- (void)audioPlaybackErrorDidOccur:(NSError*)error;
- (void)audioRecordingErrorDidOccur:(NSError*)error;
- (void)userDeniedMicrophoneAccess;

@end

@interface MPAudioManager : NSObject

@property (nonatomic) NSTimeInterval offsetFromStart;
@property (nonatomic, readonly) NSTimeInterval audioDuration;

@property (nonatomic, weak) id<MPAudioManagerDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)startPlayingFileWithLocalURL:(NSURL *)fileURL;
- (void)continuePlayback;
- (void)pausePlayback;
- (void)stopPlayback;

- (void)startRecordingWithMaxDuration:(NSTimeInterval)duration atLocalURL:(NSURL *)fileURL;
- (void)stopRecording;
- (BOOL)cancelRecording;

- (void)queryDurationOfAudioFile:(NSURL *)fileURL withCompletionBlock:(void (^)(NSURL *fileURL, float audioDurationInSeconds))queryCompletionBlock;
- (BOOL)isCurrentlyPlayingFile:(NSURL *)fileURL;

@end
