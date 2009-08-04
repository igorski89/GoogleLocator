//
//  AppDelegate.m
//  GoogleLocator
//
//  Created by Igor Evsukov on 04.08.09.
//  Copyright 2009 Igor Evsukov. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)windowShouldClose:(id)window {
    [[NSApplication sharedApplication] hide:nil];
    return NO;
}

- (IBAction)locateAddress:(id)sender {
    NSString *address = [addressTextField stringValue];
    [addressTextField setEnabled:NO];
    [locateButton setEnabled:NO];
    [locatingProcessIndicator startAnimation:nil];
    [NSThread detachNewThreadSelector:@selector(receiveCoordinatesFromGoogle:) 
                             toTarget:self
                           withObject:address];
    
}

- (void)receiveCoordinatesFromGoogle:(NSString*)address {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
	NSArray *listItems = [locationString componentsSeparatedByString:@","];    
    
    NSLog(@"coordinates for address %@:%@",address,listItems);
    
    [self performSelectorOnMainThread:@selector(setCoordinatesFromGoogleCSV:) 
                           withObject:listItems
                        waitUntilDone:YES];
    
    [pool release];
}

- (void)setCoordinatesFromGoogleCSV:(NSArray*)coordinates {
    [addressTextField setEnabled:YES];
    [locateButton setEnabled:YES];
    [locatingProcessIndicator stopAnimation:nil];
	if([coordinates count] >= 4 && [[coordinates objectAtIndex:0] isEqualToString:@"200"]) {
        [latitudeTextField setStringValue:[coordinates objectAtIndex:2]];
        [longitudeTextField setStringValue:[coordinates objectAtIndex:3]];
	} else {
        [latitudeTextField setStringValue:@""];
        [longitudeTextField setStringValue:@""];
    }    
}

@end
