#define kPrefsAppID 					CFSTR("com.candoizo.springtime")
#define kSettingsChangedNotification 	CFSTR("com.candoizo.springtime.settingschanged")
#define kSelfBundlePath @"/Library/PreferenceBundles/springtimeprefs.bundle/Toggles"

@interface FBSystemService : NSObject //telling our code to know about these methods, thank you /u/ShadeZepheri
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
-(void)exitAndRelaunch:(BOOL)arg1 withOptions:(unsigned long long)arg2;
-(void)prepareForExitAndRelaunch:(BOOL)arg1;
-(void)_performExitTasksForRelaunch:(BOOL)arg1;
-(void)shutdownAndReboot:(BOOL)arg1;
-(void)exitAndRelaunch:(BOOL)arg1 withOptions:(unsigned long long)arg2;
@end

@interface SBUIAction : NSObject //this basically explains the type of SBUI actions we can initialize, some have images
//while some dont
- (id)initWithTitle:(id)arg1 handler:(id /* block */)arg2;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 handler:(id /* block */)arg3;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 badgeView:(id)arg4 handler:(id /* block */)arg5;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 handler:(id /* block */)arg4;
@end

@protocol CCUIButtonModuleDelegate <NSObject>
@required
- (void)buttonModule:(id)arg1 willExecuteSecondaryActionWithCompletionHandler:(id /* block */)arg2;
@end

@interface CCUIButtonModule : NSObject
- (id<CCUIButtonModuleDelegate>)delegate;
@end

static NSString *theurl;
static BOOL  rcol, cellpage, lowpage, recpage, small, custom;
static void loadPreferences() {
	CFPreferencesAppSynchronize(kPrefsAppID);
	rcol = !CFPreferencesCopyAppValue(CFSTR("rcol"), kPrefsAppID) ? YES : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("rcol"), kPrefsAppID)) boolValue];
	cellpage = !CFPreferencesCopyAppValue(CFSTR("cellpage"), kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("cellpage"), kPrefsAppID)) boolValue];
  lowpage = !CFPreferencesCopyAppValue(CFSTR("lowpage"), kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("lowpage"), kPrefsAppID)) boolValue];
  recpage = !CFPreferencesCopyAppValue(CFSTR("recpage"), kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("recpage"), kPrefsAppID)) boolValue];
  small = !CFPreferencesCopyAppValue(CFSTR("small"), kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("small"), kPrefsAppID)) boolValue];
	theurl = !CFPreferencesCopyAppValue(CFSTR("theurl"), kPrefsAppID) ? nil : CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("theurl"), kPrefsAppID));
}

static void prefsCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPreferences();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIOrientationLockSetting
-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorlock = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorlock;
	}
}
%end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIBluetoothSetting
-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorblue = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorblue;
	}
}

- (int)orbBehavior { return 2;}

- (NSArray *)buttonActions{
   NSMutableArray *actions = [NSMutableArray new];
   SBUIAction *blue = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Bluetooth" subtitle:@"Go-to Bluetooth page." image:[UIImage imageNamed:@"Black_ON_Bluetooth" inBundle:[NSBundle bundleWithPath:@"/System/Library/Frameworks/UIKit.framework"]]  handler:^(void) {
 		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
 		[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil];
   }];
   [actions addObject:blue];
   return [actions copy];
}


%end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIDoNotDisturbSetting //This hooks the DND button, its really easy to change this to whatever toggle you want to add to
-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colordnd = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colordnd;
}}
//NSString *text = [prefs objectForKey:@"text"];
id sub = @"beep beep beep.";
- (int)orbBehavior {
   return 2; // returning 2 allows the 3D touch to be enabled and also tells it where to pull the options from.
}

- (NSArray *)buttonActions {
   NSMutableArray *actions = [NSMutableArray new]; //this creates a new array where we can store the buttons
    //id custom =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Application Support/Springtime/glyph.png"]];
   // SBUIAction can be thought of as an UIApplicationShortcutItem
   SBUIAction *dnd = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Respring" subtitle:sub image:[UIImage imageNamed:@"PUIrisLoading-PhotoIris" inBundle:[NSBundle bundleWithPath:@"/System/Library/Frameworks/PhotosUI.framework"]] handler:^(void)
    {
				 [[%c(FBSystemService) sharedInstance] prepareForExitAndRelaunch:YES];
				 [[%c(FBSystemService) sharedInstance] _performExitTasksForRelaunch:YES];
				[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];

       [[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
   }];
   [actions addObject:dnd]; //adds the array of toggles you've set up

   return [actions copy]; //returns a copy of the array back to the DND setting
}
%end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIWiFiSetting //custom bookmarks
-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorwifi = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorwifi;
}}
- (int)orbBehavior
{
   return 2;
}

- (NSArray *)buttonActions
{
   NSMutableArray *actions = [NSMutableArray new];
   //id url = theurl;

	 NSString *string = theurl;
 	NSString *separatorString = @"http";
 	if ([string containsString:separatorString]) {
   //HBLogWarn(@"text was : %@", arg1);
 	string = [string componentsSeparatedByString:separatorString].lastObject;
}
   SBUIAction *wifi = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:string subtitle:theurl image:[UIImage imageNamed:@"Shared-Glyph-iCloudAvailable" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Memories.framework"]] handler:^(void)
{
   		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:theurl]];
   		[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil];
   }];

   [actions addObject:wifi];
   return [actions copy];
}

%end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIAirplaneModeSetting //thanks ccabral for your code
-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorapm = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorapm;
}}
- (int)orbBehavior
{
   return 2;
}

- (NSArray *)buttonActions
{
   NSMutableArray *actions = [NSMutableArray new];


   SBUIAction *airplane = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Settings" subtitle:@"Open application" image:[UIImage imageNamed:@"PUIrisShare-off-PhotoIris" inBundle:[NSBundle bundleWithPath:@"/System/Library/Frameworks/PhotosUI.framework"]]  handler:^(void)
   {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=ROOT#AIRPLANE_MODE"]];
        [[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil];
   }];

   [actions addObject:airplane];
   return [actions copy];
}

%end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUICellularDataSetting

-(id)selectedStateColor {
  if (!rcol) {
    return %orig;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorcell = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorcell;
}}
+ (bool)isInternalButton{
  if (!cellpage) {
	return %orig;
}
else {
  return NO;
}
}

+ (bool)isSupported:(int)arg1 {
if (!cellpage) {
return %orig;
}
else {
return YES;
}}

+ (NSString *)statusOffString
{
	return @"Cellular Data: Off";
}

+ (NSString *)statusOnString
{
	return @"Cellular Data: On";
}

- (UIImage *)glyphImageForState:(UIControlState)state
{

if (!cellpage) {

return %orig;
}

else {

	if (!custom) {
  return [UIImage imageNamed:@"Radio-OrbHW" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FuseUI.framework/"]];
}
else {
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/cell.png", kSelfBundlePath]];
	if (img) {
	return img;
}
else{
 return [UIImage imageNamed:@"Radio-OrbHW" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FuseUI.framework/"]];
}}


  }}
%end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUILowPowerModeSetting

-(id)selectedStateColor {
  if (!rcol) {
    return [UIColor colorWithRed:0.81 green:0.00 blue:0.06 alpha:1.0];;
  }
  else {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *colorlpm = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return colorlpm;
}}

+ (bool)isInternalButton {
  if (!lowpage) {
	return %orig;
}
else {
  return NO;
}}
+ (bool)isSupported:(int)arg1 {


  if (!lowpage) {
	return %orig;
}
else {
  return YES;
}}
+ (NSString *)statusOffString
{
	return @"Low Power Mode: Off";
}
+ (NSString *)statusOnString
{
	return @"Low Power Mode: On";
}
- (UIImage *)glyphImageForState:(UIControlState)state{

	if (!custom) {
  return [UIImage imageNamed:@"pinDot.png" inBundle:[NSBundle bundleWithPath:@"/Applications/CoreAuthUI.app/"]];
}
else {
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/lpm.png", kSelfBundlePath]];
	if (img) {
	return img;
}
else{
 return [UIImage imageNamed:@"pinDot.png" inBundle:[NSBundle bundleWithPath:@"/Applications/CoreAuthUI.app/"]];
}}

}
- (int)orbBehavior
{
   return 2;
}
- (NSArray *)buttonActions
{
   NSMutableArray *actions = [NSMutableArray new];

   SBUIAction *power = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Reboot" subtitle:@"Power device off & on" image:[UIImage imageNamed:@"Iris-Noninteractive" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ChatKit.framework"]] handler:^(void)
{
  [[%c(FBSystemService) sharedInstance] shutdownAndReboot:YES];
   }];

   [actions addObject:power];
   return [actions copy];
}
%end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIRecordScreenShortcut
//enables Screen Recorder if the user wants it

+ (bool)isInternalButton {
  if (!recpage) {
	return %orig;
}
else {
  return NO;
}}

+(bool)isSupported:(int)arg1 {

  if (!recpage) {
	return %orig;
}
else {
  return YES;
}}

- (UIImage *)glyphImageForState:(UIControlState)state
{
if (!recpage) {
  return %orig;
}
else {

	if (!custom) {
return [UIImage imageNamed:@"RecordVideo-OrbHW" inBundle:[NSBundle bundleWithPath:@"/Applications/Camera.app/"]];
}
else {
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/rec.png", kSelfBundlePath]];
	if (img) {
	return img;
}
else{
 return [UIImage imageNamed:@"RecordVideo-OrbHW" inBundle:[NSBundle bundleWithPath:@"/Applications/Camera.app/"]];
}}





}}
%end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%hook CCUIButtonController
//this uses small buttons
-(BOOL)_usesSmallButtons {

  if (!small) {
    return NO;
  }
else {
  return YES;
}}
%end

//////////////////////////////////////////////////////////////////////////

%ctor {
	@autoreleasepool {

		loadPreferences();

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)prefsCallback,
			kSettingsChangedNotification,
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}
