//
//  MPAudioMessagePlayer.m
//  MarketPlace
//
//  Created by Arnav Jain on 18/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import AVFoundation;
@import CoreMedia;
#import "MPAudioManager.h"
#import "MPFileUtility.h"

@interface MPAudioManager() <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
{
    BOOL _isRecordingCancelled;
    BOOL _isCurrentlyPlaying;
}

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSURL *fileCurrentlyPlaying;

@end

@implementation MPAudioManager

+ (instancetype)sharedInstance
{
    static MPAudioManager *s_audioManager = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_audioManager = [[super allocWithZone:NULL]init];
    });

    return s_audioManager;
}

// Override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [MPAudioManager sharedInstance];
}

// Override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [MPAudioManager sharedInstance];
}

#pragma mark - Public Playback methods
- (void)startPlayingFileWithLocalURL:(NSURL *)fileURL
{
    assert(fileURL);
    assert([MPFileUtility isFileExist:fileURL.path]);

    // Clean up the previous playback/recording session
    [self cleanupAudioRecorder];
    [self cleanupAudioPlayer];

    NSLog(@"MPAudioManager: Instruction received to start playing file, setting up audio player");

    NSError *error;
    NSLog(@"MPAudioManager: Opening file URL: %@", fileURL.path);
    error = [self setupAudioPlayer:fileURL];

    if (error)
    {
        NSLog(@"MPAudioManager: Playback error, stopping playback for file: %@", fileURL.path);
        if ([self.delegate respondsToSelector:@selector(audioPlaybackErrorDidOccur:)])
            [self.delegate audioPlaybackErrorDidOccur:error];

        return;
    }

    self.fileCurrentlyPlaying = fileURL;
    [self.audioPlayer play];
    _isCurrentlyPlaying = YES;

    NSLog(@"MPAudioManager: Setup complete, starting playback for file: %@", fileURL.path);
    if ([self.delegate respondsToSelector:@selector(audioDidStartPlaying:)])
        [self.delegate audioDidStartPlaying:YES];
}

- (void)continuePlayback
{
    NSLog(@"MPAudioManager: Continuing playback");
    [self.audioPlayer play];
}

- (void)pausePlayback
{
    NSLog(@"MPAudioManager: Pausing playback");
    [self.audioPlayer pause];
}

- (void)stopPlayback
{
    NSLog(@"MPAudioManager: Stopping playback");
    [self.audioPlayer stop];

    self.fileCurrentlyPlaying = nil;
    _isCurrentlyPlaying = NO;

    // We are no longer interested in notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Internal playback methods
- (NSError *)setupAudioPlayer:(NSURL *)fileURL
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];

    NSLog(@"MPAudioManager: Setting up audio player for file: %@", fileURL.path);

    if (error)
    {
        NSLog(@"MPAudioManager: Error setting category: %@", error.description);
        return error;
    }

    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    if (error)
    {
        NSLog(@"MPAudioManager: Error activating AVAudioSession: %@", error.description);
        return error;
    }

    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];

    if (error)
    {
        NSLog(@"MPAudioManager: Error while initializing AVAudioPlayer: %@", error.localizedDescription);
        return error;
    }
    else if (!self.audioPlayer)
    {
        NSLog(@"MPAudioManager: AVAudioPlayer could not be initialized successfully");
        return nil;
    }

    self.audioPlayer.delegate = self;

    // Reduces latency when the audio is actually played
    [self.audioPlayer prepareToPlay];

    // We are interested in audio interruption notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];

    return nil;
}

- (void)cleanupAudioPlayer
{
    NSLog(@"MPAudioManager: Cleaning up audio player");
    [self stopPlayback];
    self.fileCurrentlyPlaying = nil;
    self.audioPlayer = nil;
}

#pragma mark - Accessor methods for properties / utility methods
- (NSTimeInterval)offsetFromStart
{
    assert(self.audioPlayer);

    return self.audioPlayer.currentTime;
}

- (void)setOffsetFromStart:(NSTimeInterval)offsetFromStart
{
    assert(self.audioPlayer);
    assert(self.audioPlayer.duration > offsetFromStart);
    assert(!(offsetFromStart < 0));

    self.offsetFromStart = self.audioPlayer.currentTime = offsetFromStart;
}

- (NSTimeInterval)audioDuration
{
    assert(self.audioPlayer);

    return self.audioPlayer.duration;
}

- (void)queryDurationOfAudioFile:(NSURL *)fileURL withCompletionBlock:(void (^)(NSURL *fileURL, float audioDurationInSeconds))queryCompletionBlock
{
    assert(fileURL);
    assert([MPFileUtility isFileExist:fileURL.path]);

    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];

    NSArray<NSString *> *keys = @[@"duration"];

    [audioAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
    {
        NSError *error = nil;
        CMTime duration;
        switch ([audioAsset statusOfValueForKey:@"duration" error:&error])
        {
            case AVKeyValueStatusLoaded:
                duration = audioAsset.duration;
                float audioDurationSeconds = CMTimeGetSeconds(duration);

                if (queryCompletionBlock)
                    queryCompletionBlock(fileURL, audioDurationSeconds);

                break;

            default:
                break;
        }
    }];
}

- (BOOL)isCurrentlyPlayingFile:(NSURL *)fileURL
{
    assert(fileURL);

    return (_isCurrentlyPlaying && [self.fileCurrentlyPlaying isEqual:fileURL]);
}

#pragma mark - AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
        NSLog(@"MPAudioManager: Playback finished successfully %@", self.fileCurrentlyPlaying.absoluteString);
    else
        NSLog(@"MPAudioManager: Playback finished unsuccessfully  %@", self.fileCurrentlyPlaying.absoluteString);

    [self stopPlayback];

    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO error:&error];

    if (error)
        NSLog(@"MPAudioManager: Error deactivating AVAudioSession: %@", error.description);

    if ( [self.delegate respondsToSelector:@selector(audioDidEndPlaying:)] )
            [self.delegate audioDidEndPlaying:flag];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"MPAudioManager: Error occurred while decoding audio file: %@", error.localizedDescription);

    if ([self.delegate respondsToSelector:@selector(audioPlaybackErrorDidOccur:)])
        [self.delegate audioPlaybackErrorDidOccur:error];
}

#pragma mark - AVAudioSession notification handler
- (void)handleAudioInterruption:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruption = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];

    switch (interruption)
    {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"MPAudioManager: Audio Interruption began");

            if ([self.delegate respondsToSelector:@selector(audioInterruptionBegan)])
                [self.delegate audioInterruptionBegan];

            break;

        case AVAudioSessionInterruptionTypeEnded:
            NSLog(@"MPAudioManager: Audio Interruption ended");

            if ([self.delegate respondsToSelector:@selector(audioInterruptionEnded)])
                [self.delegate audioInterruptionEnded];

            break;
    }
}

#pragma mark - Public Recording methods
- (void)startRecordingWithMaxDuration:(NSTimeInterval)duration atLocalURL:(NSURL *)fileURL
{
    assert(fileURL);

    // Clean up the previous playback and recording session
    [self cleanupAudioRecorder];
    [self cleanupAudioPlayer];

    NSLog(@"MPAudioManager: Instruction received to start recording, setting up recorder");
    [self checkForAuthorizationAndProceed:fileURL withDuration:duration];
}

- (void)stopRecording
{
    NSLog(@"MPAudioManager: Stopping audio recorder");
    [self.audioRecorder stop];

    // We are no longer interested in notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)cancelRecording
{
    NSLog(@"MPAudioManager: Cancelling audio recording");
    _isRecordingCancelled = YES;
    [self stopRecording];

    return [self.audioRecorder deleteRecording];
}

#pragma mark - Internal Recording methods
- (void)checkForAuthorizationAndProceed:(NSURL *)fileURL withDuration:(NSTimeInterval)duration
{
    switch ([AVAudioSession sharedInstance].recordPermission)
    {
        case AVAudioSessionRecordPermissionDenied:
            // The user denied us the microphone access earlier
            NSLog(@"MPAudioManager: Microphone permission denied");
            if ([self.delegate respondsToSelector:@selector(userDeniedMicrophoneAccess)])
                [self.delegate userDeniedMicrophoneAccess];
            break;

        case AVAudioSessionRecordPermissionGranted:
            // The user has given us the microphone access earlier
            [self setupAudioRecorder:fileURL];

            NSLog(@"MPAudioManager: Setup complete, starting recording for file: %@", fileURL.path);
            [self.audioRecorder recordForDuration:duration];

            if ([self.delegate respondsToSelector:@selector(audioDidStartRecording:)])
                [self.delegate audioDidStartRecording:YES];
            break;

        case AVAudioSessionRecordPermissionUndetermined:
        {
            // Microphone access is unknown, ask the user to provide it
            __weak MPAudioManager *weakSelf = self;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
             {
                 MPAudioManager *strongInnerSelf = weakSelf;

                 if (!granted)
                 {
                     NSLog(@"MPAudioManager: User denied microphone access");
                     if ([strongInnerSelf.delegate respondsToSelector:@selector(userDeniedMicrophoneAccess)])
                         [strongInnerSelf.delegate userDeniedMicrophoneAccess];
                 }
                 else
                 {
                     // We do not start recording if permission was granted here, instead
                     // we start recording the next time
                     NSLog(@"MPAudioManager: Ignoring first time audio recording");
                     if ([strongInnerSelf.delegate respondsToSelector:@selector(audioDidStartRecording:)])
                         [strongInnerSelf.delegate audioDidStartRecording:NO];
                 }
             }];
            break;
        }

        default:
            break;
    }
}

- (void)setupAudioRecorder:(NSURL *)fileURL
{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: &error];

    NSLog(@"MPAudioManager: Setting up recorder for file: %@", fileURL.path);

    if (error)
    {
        NSLog(@"MPAudioManager: Error setting category: %@", error.description);

        if ([self.delegate respondsToSelector:@selector(audioRecordingErrorDidOccur:)])
            [self.delegate audioRecordingErrorDidOccur:error];
    }

    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    if (error)
    {
        NSLog(@"MPAudioManager: Error activating AVAudioSession: %@", error.description);

        if ([self.delegate respondsToSelector:@selector(audioRecordingErrorDidOccur:)])
            [self.delegate audioRecordingErrorDidOccur:error];
    }

    NSMutableDictionary<NSString *, id> *recorderSettings = [[NSMutableDictionary alloc] init];
    [recorderSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recorderSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recorderSettings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];

    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL
                                                     settings:recorderSettings
                                                        error:&error];

    if (error)
    {
        NSLog(@"MPAudioManager: Error while initializing AVAudioRecorder: %@", error.localizedDescription);

        if ([self.delegate respondsToSelector:@selector(audioRecordingErrorDidOccur:)])
            [self.delegate audioRecordingErrorDidOccur:error];
    }
    else if (!self.audioRecorder)
    {
        NSLog(@"MPAudioManager: AVAudioRecorder could not be initialized successfully");
    }

    self.audioRecorder.delegate = self;

    // Reduces latency when the audio is actually played
    [self.audioRecorder prepareToRecord];

    // We are interested in audio interruption notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
}

- (void)cleanupAudioRecorder
{
    NSLog(@"MPAudioManager: Cleaning up audio recorder");
    [self stopRecording];

    _isRecordingCancelled = NO;

    self.audioRecorder = nil;
}

#pragma mark - AVAudioRecorderDelegate methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag)
        NSLog(@"MPAudioManager: Recording finished successfully");
    else
        NSLog(@"MPAudioManager: Recording finished unsuccessfully");

    if (_isRecordingCancelled)
        flag = NO;

    if ( [self.delegate respondsToSelector:@selector(audioDidEndRecording:)] )
            [self.delegate audioDidEndRecording:flag];

    [self cleanupAudioRecorder];

    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO error:&error];

    if (error)
        NSLog(@"MPAudioManager: Error deactivating AVAudioSession: %@", error.description);
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)player error:(NSError *)error
{
    NSLog(@"MPAudioManager: Error occurred while decoding audio file: %@", error.localizedDescription);

    if ([self.delegate respondsToSelector:@selector(audioRecordingErrorDidOccur:)])
        [self.delegate audioRecordingErrorDidOccur:error];
}

@end
