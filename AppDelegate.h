//
//  AppDelegate.h
//  GoogleLocator
//
//  Created by Igor Evsukov on 04.08.09.
//  Copyright 2009 Igor Evsukov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppDelegate : NSObject {
    IBOutlet NSTextField *addressTextField;
    IBOutlet NSTextField *latitudeTextField;
    IBOutlet NSTextField *longitudeTextField;
    IBOutlet NSButton *locateButton;
    IBOutlet NSProgressIndicator *locatingProcessIndicator;
}

- (IBAction)locateAddress:(id)sender;

- (void)receiveCoordinatesFromGoogle:(NSString*)address;

@end
