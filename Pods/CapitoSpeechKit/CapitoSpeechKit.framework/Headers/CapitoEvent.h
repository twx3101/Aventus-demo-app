//
//  CapitoEvent.h
//  Capito Speech Kit
//
//  Created by Darren Harris on 02/12/14.
//
//

#import <Foundation/Foundation.h>

@interface CapitoEvent : NSObject

/*!
 @abstract Status for event
 */
typedef NSUInteger CAPEventStatus;

enum CAPEventStatus {
    CAPEventStatusActive = 0,
    CAPEventStatusDirty = 1,
    CAPEventStatusComplete = 2,
    CAPEventStatusCancelled = 3,
    CAPEventStatusError = 4
};

@property (strong, nonatomic) NSNumber *eventId;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *transcription;
@property (strong, nonatomic) NSString *commandType;
@property (strong, nonatomic) NSMutableDictionary *appContext;
@property (strong, nonatomic) NSMutableArray *slots;
@property (strong, nonatomic) NSNumber *correct;
@property (strong, nonatomic) NSString *eventType;
@property (nonatomic, assign) CAPEventStatus status;

- (id)  initWithContext:(NSDictionary *)theContext;

@end
