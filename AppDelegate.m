//
//  AppDelegate.m
//  GoogleLocator
//
//  Created by Igor Evsukov on 04.08.09.
//  Copyright 2009 Igor Evsukov. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

-(void)awakeFromNib {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"googlemaps" withExtension:@"html"];
    [[googleMapsWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    [[[googleMapsWebView mainFrame] frameView] setAllowsScrolling:NO];
    [googleMapsWebView setNeedsDisplay:YES];    
}

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
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString *locationString = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"%@",locationString);
	NSArray *listItems = [locationString componentsSeparatedByString:@","];    
    
    NSLog(@"coordinates for address %@:%@",address,listItems);
    
    [self performSelectorOnMainThread:@selector(setCoordinatesFromGoogleCSV:) 
                           withObject:listItems
                        waitUntilDone:YES];
    
    [pool release];
}

- (IBAction)zoomButtonPressed:(id)sender {
    if (sender == mapZoomSegmentedControl) {
        if ([mapZoomSegmentedControl selectedSegment] == 0) {
            id map = [googleMapsWebView windowScriptObject];
            NSString *jsCmd = @"map.zoomIn();";
            [map evaluateWebScript:jsCmd];
        }
        else {
            id map = [googleMapsWebView windowScriptObject];
            NSString *jsCmd = @"map.zoomOut();";
            [map evaluateWebScript:jsCmd];
        }
    }
}

- (IBAction)mapModeSegmentedControlSelectedChanged:(id)sender {
    if (sender == mapModeSegmentedControl) {
        id map = [googleMapsWebView windowScriptObject];
        NSString *mapType = nil;
        if ([mapModeSegmentedControl selectedSegment] == 0) {
            mapType = @"G_NORMAL_MAP";
        }
        else if ([mapModeSegmentedControl selectedSegment] == 1) {
            mapType = @"G_SATELLITE_MAP";
        }
        else {
            mapType = @"G_HYBRID_MAP";
        }
        NSString *jsCmd = [NSString stringWithFormat:@"map.setMapType(%@);",mapType];
        [map evaluateWebScript:jsCmd];
    }
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
    NSMutableString *jsCmd = [NSMutableString string];
    [jsCmd appendString:@"map.clearOverlays();"];
    [jsCmd appendFormat:@"map.setCenter(new GLatLng(%@, %@), 13);",[coordinates objectAtIndex:2],[coordinates objectAtIndex:3]];
    [jsCmd appendFormat:@"map.addOverlay(new GMarker(new GLatLng(%@,%@)));",[coordinates objectAtIndex:2],[coordinates objectAtIndex:3]];
    
    id map = [googleMapsWebView windowScriptObject];
    [map evaluateWebScript:jsCmd];
}

@end
