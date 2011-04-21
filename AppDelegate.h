//
//  AppDelegate.h
//  GoogleLocator
//
//  Created by Igor Evsukov on 04.08.09.
//  Copyright 2009 Igor Evsukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject {
    IBOutlet NSTextField *addressTextField;
    IBOutlet NSTextField *latitudeTextField;
    IBOutlet NSTextField *longitudeTextField;
    IBOutlet NSButton *locateButton;
    IBOutlet NSProgressIndicator *locatingProcessIndicator;
    IBOutlet WebView *googleMapsWebView;
    IBOutlet NSSegmentedControl *mapZoomSegmentedControl;
    IBOutlet NSSegmentedControl *mapModeSegmentedControl;
    NSSegmentedControl *mapModeSegmentedControlSelectedChanged;
}

- (IBAction)locateAddress:(id)sender;

- (void)receiveCoordinatesFromGoogle:(NSString*)address;
- (IBAction)zoomButtonPressed:(id)sender;
- (IBAction)mapModeSegmentedControlSelectedChanged:(id)sender;

@end
