#include <spawn.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSTableCell.h>
#import <Social/Social.h>

//CGFloat huee = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//CGFloat saturationn = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//CGFloat brightnesss = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
#define kRandomColor [UIColor colorWithHue:huee saturation:saturationn brightness:brightnesss alpha:1]
#define kSelfBundlePath @"/Library/PreferenceBundles/springtimeprefs.bundle"
//#define kBarTintColor [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:1.0]
//#define kTintColor [UIColor colorWithRed:0.89 green:0.69 blue:0.03 alpha:1.0] //ac3838
#define kHeaderHeight 70.0f
#define kNumberOfButtons 5.0f
#define kButtonSize 60.0f
#define kSpacersNeeded 4.0f



@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface PSListController ()
-(void)clearCache;
-(void)reload;
-(void)viewWillAppear:(BOOL)animated;
@end

@interface CSLShared : NSObject
+(NSString *)localisedStringForKey:(NSString *)key;
+(void)parseSpecifiers:(NSArray *)specifiers;
@end

@implementation CSLShared

+(NSString *)localisedStringForKey:(NSString *)key {
	NSString *englishString = [[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/en.lproj",kSelfBundlePath]] localizedStringForKey:key value:@"" table:nil];
	return [[NSBundle bundleWithPath:kSelfBundlePath] localizedStringForKey:key value:englishString table:nil];
}

+(void)parseSpecifiers:(NSArray *)specifiers {
	for (PSSpecifier *specifier in specifiers) {
		NSString *localisedTitle = [CSLShared localisedStringForKey:specifier.properties[@"label"]];
		NSString *localisedFooter = [CSLShared localisedStringForKey:specifier.properties[@"footerText"]];
		[specifier setProperty:localisedFooter forKey:@"footerText"];
		specifier.name = localisedTitle;
	}
}
@end

@interface springtimeprefsListController: PSListController {
}
@end

@implementation springtimeprefsListController

CGFloat huee = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
CGFloat saturationn = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
CGFloat brightnesss = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 2) {
		return kHeaderHeight;
	} else {
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 2) {
		UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){{0, 0}, {320, kHeaderHeight}}];
		headerView.backgroundColor = UIColor.clearColor;
		headerView.clipsToBounds = YES;


		// title
		CGRect frame = CGRectMake(0, 0, headerView.bounds.size.width, 70);
		UILabel *tweakTitle = [[UILabel alloc] initWithFrame:frame];
		tweakTitle.font = [UIFont fontWithName:@"GillSans-LightItalic" size:48];
		tweakTitle.text = @"Wormhole 🌌";
		tweakTitle.textColor = UIColor.purpleColor;
		tweakTitle.textAlignment = NSTextAlignmentCenter;
		tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[headerView addSubview:tweakTitle];

		return headerView;
	} else {
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}


- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"springtimeprefs" target:self] retain];
	}
	[CSLShared parseSpecifiers:_specifiers];
	return _specifiers;
}
- (void)viewDidLoad {
	[super viewDidLoad];

	//self.title = @""; this sets the middle title

	//UIImage *meImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/me.png", kSelfBundlePath]];
	//UIBarButtonItem *meButton = [[UIBarButtonItem alloc] initWithImage:meImage style:UIBarButtonItemStylePlain target:self action:@selector(twitterButton)];
	//meButton.imageInsets = (UIEdgeInsets){2, 0, -2, 0};
	//[self.navigationItem setRightBarButtonItem:meButton];
	//[self.titleView customCell:meButton]; need to finda way to declare a button called profile with photo & link below

	// add a heart button to the navbar
/*	UIImage *heartImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/heart.png", kSelfBundlePath]];
	UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithImage:heartImage style:UIBarButtonItemStylePlain target:self action:@selector(showLove)];
	heartButton.imageInsets = (UIEdgeInsets){2, 0, -2, 0};
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	heartButton.tintColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
*/
/*
UIImage *meImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/me.png", kSelfBundlePath]];
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [button setImage:meImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(twitterButton) forControlEvents:UIControlEventTouchUpInside];
	//	[button addTarget:self action:@selector(fireButton) forControlEvents:UIControlEventTouchCancel];
    self.navigationItem.titleView = button;*/

		UIImage *meImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/me.png", kSelfBundlePath]];
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];

		    [button setImage:meImage forState:UIControlStateNormal];
		    [button addTarget:self action:@selector(twitterButton) forControlEvents:UIControlEventTouchUpInside];
				CGRect copyrect = button.layer.bounds;
				CGFloat copyx = copyrect.size.width;
				CGFloat newsize =	copyx/2.1;
			  button.layer.cornerRadius = newsize;
				button.layer.borderWidth = 2;
				button.layer.borderColor = CGColorRetain(kRandomColor.CGColor);
			  self.navigationItem.titleView = button;



		//  self.navigationItem.titleView = button;



	// music button
	UIImage *musicImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/heart.png", kSelfBundlePath]];
	UIBarButtonItem *musicButton = [[UIBarButtonItem alloc] initWithImage:musicImage style:UIBarButtonItemStylePlain target:self action:@selector(showLove)];
	musicButton.imageInsets = (UIEdgeInsets){2, 0, -2, 0};
	/*CGFloat huee = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturationn = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightnesss = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	musicButton.tintColor = [UIColor colorWithHue:huee saturation:saturationn brightness:brightnesss alpha:1];*/
	musicButton.tintColor = kRandomColor;

	//add to views

	//[self.navigationItem setRightBarButtonItems:heartButton, musicButton];
	[self.navigationItem setRightBarButtonItem:musicButton];
	//[self.navigationItem setRightBarButtonItem:heartButton];
	// add a profile pic / social button to the navbar
	/*


*/

}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// tint navbar
	//self.navigationController.navigationController.navigationBar.barTintColor = kBarTintColor;
	self.navigationController.navigationController.navigationBar.tintColor = kRandomColor;
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// un-tint navbar
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	//self.navigationController.navigationController.navigationBar.barTintColor = nil;
}


-(void)twitterButton {
	NSString *user = @"candoizo";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];

}
-(void)showLove {
	//playlists/303896337
	NSString *track = @"72657719";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"soundcloud:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"soundcloud://tracks:" stringByAppendingString:track]]];
		else
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://soundcloud.com/flatbushzombies/flatbush-zombies-mraz" stringByAppendingString:@""]]];
}


@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////BUTTONS ARE ABOVE, OTHER SHIT IS BELOW////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
@interface notoriousTitleCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *tweakTitle;

}

@end

@implementation notoriousTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		// icon

		int width = self.contentView.bounds.size.width;

		CGRect frame = CGRectMake(0, 20, width, 60);


		UIImage *icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/springtimeprefs.png", kSelfBundlePath]];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		[self addSubview:iconView];

		tweakTitle = [[UILabel alloc] initWithFrame:frame];
		[tweakTitle setNumberOfLines:1];
		[tweakTitle setFont:[UIFont fontWithName:@"GillSans-LightItalic" size:48]];
		[tweakTitle setText:@"notorious 🎵"];
		[tweakTitle setBackgroundColor:[UIColor clearColor]];
		[tweakTitle setTextColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0]];
		[tweakTitle setTextAlignment:NSTextAlignmentCenter];
		tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tweakTitle.contentMode = UIViewContentModeScaleToFill;



		[self addSubview:tweakTitle];
	}

	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notoriousTitleCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 125.0f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
}

@end*/

@interface springtimeCreditCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *tweakCredit;
}

@end

@implementation springtimeCreditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		// icon
		/*
		UIImage *bugImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Bug.png", kSelfBundlePath]];
		UIButton *bugbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
		[bugbutton setImage:bugImage forState:UIControlStateNormal];
		[bugbutton addTarget:self action:@selector(bugButton) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:bugbutton];

		UIImage *paypalImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Paypal.png", kSelfBundlePath]];
		UIButton *paypalbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
		[paypalbutton setImage:paypalImage forState:UIControlStateNormal];
		[paypalbutton addTarget:self action:@selector(paypalButton) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:paypalbutton];

		UIImage *bugicon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/can.png", kSelfBundlePath]];
		UIImageView *bugiconView = [[UIImageView alloc] initWithImage:bugicon];
		bugiconView.frame = (CGRect){{0, 21}, bugiconView.frame.size};
		bugiconView.center = (CGPoint){self.center.x, bugiconView.center.y};
		bugiconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[self addSubview:bugiconView];*/

		int width = self.contentView.bounds.size.width;
		CGRect subtitleeFrame = CGRectMake(0, 6, width, 9);


		tweakCredit = [[UILabel alloc] initWithFrame:subtitleeFrame];
		[tweakCredit setNumberOfLines:1];
		[tweakCredit setFont:[UIFont fontWithName:@"GillSans-LightItalic" size:9]];
		[tweakCredit setText:@"♪ But since I came, developed my name ♪"];
		[tweakCredit setBackgroundColor:[UIColor clearColor]];
		[tweakCredit setTextColor: [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0]];
		[tweakCredit setTextAlignment:NSTextAlignmentCenter];
		tweakCredit.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tweakCredit.contentMode = UIViewContentModeScaleToFill;

		[self addSubview:tweakCredit];
	}

	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notoriousCreditCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 20.0f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
}

@end


@interface masqButtonCell : PSTableCell <PreferencesTableCustomView> {

}

@end

@implementation masqButtonCell


-(void)fireButton {
	//playlists/303896337
	NSString *track = @"72657719";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"soundcloud:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"soundcloud://tracks:" stringByAppendingString:track]]];
		else
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://soundcloud.com/flatbushzombies/flatbush-zombies-mraz" stringByAppendingString:@""]]];
}


-(void)bugButton {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ghostbin.com/paste/gdjjn"]];
}

-(void)paypalButton {
		NSString *userr = @"andreasott";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://www.paypal.me/" stringByAppendingString:userr]]];
}


-(void)btcButton {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://s31.postimg.org/dufu1c897/g_VVu_LWE.png"]];
}
-(void)mailButton {
	NSString *url = @"https://cydia.saurik.com/api/support/com.candoizo.springtime";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"cydia://url/" stringByAppendingString:url]]];
		else
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cydia.saurik.com/api/support/com.candoizo.springtime"]];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];



	if (self) {
	//CGPoint point = self.center;
		//CGFloat width = [UIScreen mainScreen].bounds.size.width;
		// CGFloat leftover = (width - (kNumberOfButtons * kButtonSize)); //4 = number of buttons, 70 = width of them all is usually constant

		// button 1
		UIImage *bugImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Bug.png", kSelfBundlePath]];
		 	UIButton *bugbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
  	[bugbutton setImage:bugImage forState:UIControlStateNormal];
    [bugbutton addTarget:self action:@selector(bugButton) forControlEvents:UIControlEventTouchUpInside];
		[bugbutton.heightAnchor constraintEqualToConstant:kButtonSize].active = true;
	 [bugbutton.widthAnchor constraintEqualToConstant:kButtonSize].active = true;



		//button 2
		UIImage *paypalImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Paypal.png", kSelfBundlePath]];
	   	UIButton *paypalbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
  	[paypalbutton setImage:paypalImage forState:UIControlStateNormal];
    [paypalbutton addTarget:self action:@selector(paypalButton) forControlEvents:UIControlEventTouchUpInside];
	 [paypalbutton.heightAnchor constraintEqualToConstant:kButtonSize].active = true;
   [paypalbutton.widthAnchor constraintEqualToConstant:kButtonSize].active = true;


		//button 3
		UIImage *btcImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/bitcoin.png", kSelfBundlePath]];
	UIButton *btcbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
		[btcbutton setImage:btcImage forState:UIControlStateNormal];
		[btcbutton addTarget:self action:@selector(btcButton) forControlEvents:UIControlEventTouchUpInside];
		[btcbutton.heightAnchor constraintEqualToConstant:kButtonSize].active = true;
	 [btcbutton.widthAnchor constraintEqualToConstant:kButtonSize].active = true;



//button 4
UIImage *mailImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/mail.png", kSelfBundlePath]];
UIButton *mailbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
[mailbutton setImage:mailImage forState:UIControlStateNormal];
[mailbutton addTarget:self action:@selector(mailButton) forControlEvents:UIControlEventTouchUpInside];
[mailbutton.heightAnchor constraintEqualToConstant:kButtonSize].active = true;
[mailbutton.widthAnchor constraintEqualToConstant:kButtonSize].active = true;



		UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.bounds];

		stackView.axis = UILayoutConstraintAxisHorizontal;
		stackView.distribution = UIStackViewDistributionFillProportionally;
		stackView.alignment = UIStackViewAlignmentCenter;
		stackView.spacing = 13;
		[stackView addArrangedSubview:bugbutton];
		[stackView addArrangedSubview:btcbutton];
		[stackView addArrangedSubview:paypalbutton];
	//	[stackView addArrangedSubview:musicbutton];
		[stackView addArrangedSubview:mailbutton];
		//
		UIStackView *verticalstackView = [[UIStackView alloc] initWithFrame:self.bounds];
		verticalstackView.axis = UILayoutConstraintAxisVertical;
		verticalstackView.distribution = UIStackViewAlignmentFill;
		verticalstackView.alignment = UIStackViewAlignmentCenter;

		 verticalstackView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

		[verticalstackView addArrangedSubview:stackView];
		[self addSubview:verticalstackView];
	}
	return self;

}
- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"masqButtonCell" specifier:specifier];
}
- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 70.0f;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
}
@end
