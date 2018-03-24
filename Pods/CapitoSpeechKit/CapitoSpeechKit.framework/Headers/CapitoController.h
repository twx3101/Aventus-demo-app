//
//  CapitoController.h
//  (C) Capito Systems Ltd 2013, All Rights Reserved.
//
//  This class is the device API for communicating
//  with the Capito Cloud
//
//  Created by Darren Harris on 3/14/13.
//
//

#import <Foundation/Foundation.h>
#import "CapitoResponse.h"
#import "CapitoTranscription.h"
#import "CapitoEvent.h"

#define HOST                            @"host"
#define PATH                            @"path"
#define USESSL                          @"useSSL"
#define MODE                            @"mode"
#define LANGUAGE                        @"lang"
#define APPVERSION                      @"appVersion"
#define TESTCASE                        @"testCase"
#define EVENT                           @"eventType"
#define VOICEPROMPT                     @"voicePrompt"
#define VOICESTART                      @"voiceStart"
#define VOICESTOP                       @"voiceStop"
#define VOICECANCEL                     @"voiceCancel"
#define kCAPModeArray                   @"SR", @"T", @"L", @"M", nil
#define kCAPEventTypeArray              @"NAV", @"SEL", @"DSEL", @"TRAN", @"SRCH", @"COMP", @"LOG", nil
#define kCAPCommandTypeArray            @"TCH", @"TXT", @"VOX", nil

/*!
 @abstract Type for the Voice Biometrics return type
 */
typedef NS_ENUM(NSUInteger, CAPBiometricsStatus) {
    CAPBiometricsNotRegistered = 0,
    CAPBiometricsRegistered = 1,
    CAPBiometricsLoginSuccess = 2,
    CAPBiometricsLoginFailed = 3,
    CAPBiometricsUnknown = 4
};

/*!
 @abstract Type for the Capito Command Type
 */
typedef NS_ENUM(NSUInteger, CAPCommandType) {
    CAPTouchCommand = 0,
    CAPTextCommand = 1,
    CAPVoiceCommand = 2,
    CAPConnectCommand = 3
};

/*!
 @abstract Type for the Capito Voice/CAPTouch Operations Mode
 */
typedef NS_ENUM(NSUInteger, CAPModeType) {
    CAPModeStaticResponse = 0,
    CAPModeTest = 1,
    CAPModeLive = 2,
    CAPModeManual = 3
    };

/*!
 @abstract Type for the Capito Event Type
 */
typedef NS_ENUM(NSUInteger, CAPEventType) {
    CAPNavigate = 0,
    CAPSelect = 1,
    CAPUnSelect = 2,
    CAPTransact = 3,
    CAPSearch = 4,
    CAPComplete = 5,
    CAPLog = 6
};

@protocol ContextualDelegate <NSObject>
@optional
- (void) contextControllerDidFinishWithSuccess:(CapitoResponse *)response;
- (void) contextControllerDidFinishWithError:(NSError *)error;
@end

@protocol VoiceBiometricsDelegate <NSObject>
@optional
- (void) biometricsControllerDidBeginRecording:(NSString *)say forSecs:(int)recordingInterval;
- (void) biometricsControllerDidFinishRecording;
- (void) biometricsControllerProcessing;
- (void) biometricsControllerDidFinishWithSuccess:(CAPBiometricsStatus)status;
- (void) biometricsControllerDidDeRegisterUser;
- (void) biometricsControllerDidFinishWithError:(NSError *)error;
@end

@protocol SpeechDelegate <NSObject>
@required
- (void) speechControllerDidBeginRecording;
- (void) speechControllerDidFinishRecording;
- (void) speechControllerProcessing:(CapitoTranscription *)transcription suggestion:(NSString *)suggestion;
- (void) speechControllerDidFinishWithResults:(CapitoResponse *)response;
- (void) speechControllerDidFinishWithError:(NSError *)error;
@end

@protocol TouchDelegate <NSObject>
@optional
- (void) touchControllerDidFinishWithResults:(CapitoResponse *)response;
- (void) touchControllerDidFinishWithError:(NSError *)error;
@end

@protocol TextDelegate <NSObject>
@optional
- (void) textControllerDidFinishWithResults:(CapitoResponse *)response;
- (void) textControllerDidFinishWithError:(NSError *)error;
@end


@interface CapitoController : NSObject

@property (nonatomic, readonly, getter=isLastEventTouch) BOOL lastEventTouch;
@property (nonatomic, readonly, getter=isLastEventVoice) BOOL lastEventVoice;
@property (nonatomic, readonly, getter=isLastEventText) BOOL lastEventText;
@property (nonatomic, readonly) float audioLevel;
@property (nonatomic, readonly, getter=isUserLoggedIn) BOOL userLoggedIn;
@property (nonatomic, readonly, getter=isUserRegistered) BOOL userRegistered;

//possible connect return values
extern NSString * const kCapitoConnect_SUCCESS;
extern NSString * const kCapitoConnect_EXPIRED;
extern NSString * const kCapitoConnect_UNAVAILABLE;
extern NSString * const kCapitoConnect_NOTSETUP;

+ (CapitoController *) getInstance;

/*!
 set-up method for initialising the Capito CAPSpeech Kit
 */
- (void)setupWithID:(NSString*) ID
               host:(NSString*) host
               port:(NSNumber*) port
             useSSL:(BOOL) ssl;

+ (CAPEventType)eventType:(NSString *)event;
+ (CAPModeType)modeType:(NSString *)mode;
+ (CAPCommandType)commandType:(NSString *)command;

- (void)pushToTalk: (id <SpeechDelegate>)speechDelegate withDialogueContext:( NSDictionary *)context;
- (void)cancelTalking;
- (void)confirm:(CAPCommandType)type isCorrect:(BOOL)correct;
- (void)confirmSelection:(CAPCommandType)type withIndex:(int)index;
- (void)submitCorrection:(id <ContextualDelegate>)contextDelegate forEvent:(CapitoEvent *)event;

- (void)text:(id <TextDelegate>)textDelegate input:(NSString *)text withDialogueContext:(NSDictionary *)context;
- (void)touch:(id <TouchDelegate>)touchDelegate eventType:(CAPEventType)eventType event:(NSString *)event dialogueContext:(NSDictionary *)context withResponse:(BOOL)expected;
- (void)touch:(id <TouchDelegate>)touchDelegate eventType:(CAPEventType)eventType event:(NSString *)event dialogueContext:(NSDictionary *)context;

/**
 Test To Speach section
 **/
- (void)textToSpeech:(NSString *)text;
- (void)cancelTextToSpeech;

- (NSString *)connect;
- (void)disconnect;

/*!
 coords is a dictionary with <NSString> key and <NSString> value
 e.g.       lat = 0;
            long = 0;
 */
- (void)setGeoLocation:(NSDictionary *)coords;

/*!
 User session management methods.
 Voice Biometrics can only register and log in a single user per app per device
 */
- (void)registerUser:(id <VoiceBiometricsDelegate>)biometricsDelegate;
- (void)loginUser:(id <VoiceBiometricsDelegate>)biometricsDelegate;
- (BOOL)logoutUser;
- (void)deRegisterUser:(id <VoiceBiometricsDelegate>)biometricsDelegate;

@end
