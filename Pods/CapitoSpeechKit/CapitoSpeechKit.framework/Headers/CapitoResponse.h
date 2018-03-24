//
//  CapitoResponse.h
//  (C) Capito Systems Ltd 2013, All Rights Reserved.
//
//  This class is the device API for communicating
//  with the Capito Cloud
//
//  Created by Darren Harris on 3/14/13.
//
//

#import <Foundation/Foundation.h>

@interface CapitoResponse : NSObject

@property (nonatomic) NSString *message;
@property (nonatomic) NSString *messageType;
@property (nonatomic) NSNumber *responseCode;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *task;
@property (nonatomic) NSString *domain;
@property (nonatomic) NSString *inputText;
@property (nonatomic) NSArray  *asrs;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *eventType;
@property (nonatomic) NSString *commandType;
@property (nonatomic) NSArray *data;
@property (nonatomic) NSDictionary *context;
@property (nonatomic) NSDictionary *semanticOutput;
@property (nonatomic) NSArray *relatedSearches;

@property (nonatomic, copy, readonly) NSArray<NSString *> *keys;

@end
