//
//  CAPSettings.h
//  CapitoSpeechKit
//
//  Created by Darren Harris on 17/02/14.
//  Copyright (c) 2014 Capito Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapitoController.h"

@interface CAPSettings : NSObject

+ (CAPSettings *) getInstance;

- (void) useDictation:      (BOOL)yesorno;
- (void) streamVoice:       (BOOL)yesorno;
- (void) useVocabList:      (BOOL)yesorno;

- (void) useVoicePrompt:    (BOOL)yeorno;
- (void) setVoiceCancel:    (NSString *)voiceCancel;
- (void) setVoiceStop:      (NSString *)voiceStop;
- (void) setVoiceStart:     (NSString *)voiceStart;

- (void) setTestCase:       (NSString *)testCase;
- (void) setMode:           (CAPModeType )mode;
- (void) setLanguage:       (NSString *)language;
- (void) setAppVersion:     (NSString *)appVersion;

- (BOOL) useDictation;
- (BOOL) streamVoice;
- (BOOL) useVocabList;

- (BOOL) useVoicePrompt;
- (NSString *) voiceStop;
- (NSString *) voiceCancel;
- (NSString *) voiceStart;

- (NSString *) testCase;
- (CAPModeType) mode;
- (NSString *) language;
- (NSString *)  appVersion;

@property (nonatomic, copy) NSString *speechHintType;
@property (nonatomic, assign) BOOL uploadAudioFile;
@property (nonatomic, assign) NSTimeInterval silenceDetectionTime;

@end
