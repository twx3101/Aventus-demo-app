//
//  CapitoTranscription.h
//  CapitoSpeechKit
//
//  Created by Darren Harris on 5/21/13.
//  Copyright (c) 2013 Capito Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CapitoTranscription : NSObject

@property (nonatomic, retain) NSArray *transcriptions;
@property (nonatomic, retain) NSString *suggestion;

- (NSString*) description;
- (NSString*) firstResult;

@end
