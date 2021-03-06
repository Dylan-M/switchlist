//
//  LayoutDetailsTabViewController.m
//  SwitchList
//
//  Created by Robert Bowdidge on 9/21/12.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE.

#import "LayoutDetailsViewController.h"

#import "AppDelegate.h"
#import "ChooseTemplateViewController.h"
#import "MainWindowViewController.h"

@interface LayoutDetailsViewController ()
@property (nonatomic,retain) IBOutlet UIButton *templateButton;
@end

@implementation LayoutDetailsViewController

- (void) viewDidLoad {
    AppDelegate *myAppDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    EntireLayout *entireLayout = myAppDelegate.entireLayout;
    self.title = [NSString stringWithFormat: @"Layout Settings for %@", entireLayout.layoutName];
}

- (void) viewWillAppear: (BOOL) animated {
    AppDelegate *myAppDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    EntireLayout *entireLayout = myAppDelegate.entireLayout;
    NSString *templateName = myAppDelegate.preferredTemplateStyle;
    if (!templateName) {
        templateName = @"Handwritten";
    }
    [self.templateButton setTitle: templateName forState: UIControlStateNormal];
    [self.templateButton setTitle: templateName forState: UIControlStateSelected];
    
    self.datePicker.date = entireLayout.currentDate;
	NSMutableDictionary *layoutPrefs = [entireLayout getPreferencesDictionary];
    NSNumber *shouldUseDoors = [layoutPrefs objectForKey: LAYOUT_PREFS_SHOW_DOORS_UI];
    NSNumber *shouldLimitLengths = [layoutPrefs objectForKey: LAYOUT_PREFS_SHOW_SIDING_LENGTH_UI];
    [self.useDoorsControl setSelectedSegmentIndex: ([shouldUseDoors boolValue] ? 0 : 1)];
    [self.limitTrainLengthsControl setSelectedSegmentIndex: ([shouldLimitLengths boolValue] ? 0 : 1)];
    
}

- (IBAction) layoutNameChanged: (id) sender {
}

- (IBAction) dateChanged: (id) sender {
    AppDelegate *myAppDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    EntireLayout *entireLayout = myAppDelegate.entireLayout;
    entireLayout.currentDate = self.datePicker.date;
}

- (IBAction) specificDoorsSwitchChanged: (id) sender {
}
- (IBAction) limitTrainLengthSwitchChanged: (id) sender {
}


// Switch from this scene to another.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"templateSegue"]) {
        ChooseTemplateViewController *controller = segue.destinationViewController;
        controller.myPopoverController = ((UIStoryboardPopoverSegue*)segue).popoverController;
        controller.layoutDetailsController = self;
        
    }
}

- (IBAction) templateNameChanged: (NSString*) templateName {
    AppDelegate *myAppDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    [self.templateButton setTitle: templateName forState: UIControlStateNormal];
    [self.templateButton setTitle: templateName forState: UIControlStateSelected];

    myAppDelegate.preferredTemplateStyle = templateName;
    [myAppDelegate.mainWindowViewController noteRegenerateSwitchlists];
}
@end
