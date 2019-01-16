#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface SBTodayTableHeaderView : UIView
-(NSString *)lunarDateHeaderString;
@end

@interface SBAnimationSettings
@end

@interface SBFadeAnimationSettings
@property(retain, nonatomic) SBAnimationSettings *dateInSettings;
@end

@interface SBFLockScreenDateView : UIView
@property (nonatomic, assign) UILabel *duplexCalendarLabel;
@property (nonatomic, assign) NSString *todayHeaderViewText;
@property bool dateHidden;
-(id)_dateFont;
-(id)_dateColor;
-(BOOL)isDateHidden;
-(void)layoutDuplexCalendarLabel;
@end


@interface _UILegibilityView : UIView
@end 

@interface _UILegibilityLabel : _UILegibilityView
@end

extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);
static NSString *myObserver=@"duplexcalendarObserver";
static NSString *settingsPath = @"/var/mobile/Library/Preferences/com.gilshahar7.duplexcalendarprefs.plist";
static NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

static void savePressed(){
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
}

static void savePressed(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
}

static SBTodayTableHeaderView *stattodayHeaderView;
static float originx = 0.0;
static float originy = 0.0;
static float sizewidth = 0.0;
static float sizeheight = 0.0;

%hook SBTodayTableHeaderView
-(SBTodayTableHeaderView *)initWithFrame:(CGRect)arg1{
	stattodayHeaderView = %orig();
	return stattodayHeaderView;
}
%end

%hook SBFLockScreenDateView
%property (nonatomic, assign) UILabel *duplexCalendarLabel;
%property (nonatomic, assign) NSString *todayHeaderViewText;
-(SBFLockScreenDateView *)initWithFrame:(id)arg1{
	SBFLockScreenDateView *origself = %orig(arg1);
	if(!self.duplexCalendarLabel){
		self.duplexCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(originx-50, originy + 19, sizewidth+100, sizeheight)];
		self.duplexCalendarLabel.font = [[self _dateFont] fontWithSize:16];
		[self addSubview:self.duplexCalendarLabel];
		self.duplexCalendarLabel.textColor = [self _dateColor];
		self.duplexCalendarLabel.textAlignment = 1;
	}
	return origself;
}

%new
-(void)layoutDuplexCalendarLabel{
	NSString *offsetXTextField = [prefs objectForKey:@"offsetXTextField"];
	NSString *offsetYTextField = [prefs objectForKey:@"offsetYTextField"];
	NSString *FontSizeTextField = [prefs objectForKey:@"FontSizeTextField"];	
	
	//if(originx <= 0.0)
	//{
		UILabel *originalLabel = MSHookIvar<UILabel *>(self, "_dateLabel");
		originx = originalLabel.frame.origin.x;
		originy = originalLabel.frame.origin.y;
		sizewidth = originalLabel.frame.size.width;
		sizeheight = originalLabel.frame.size.height;
	//}
	[self.duplexCalendarLabel setFrame:CGRectMake(originx-50+ [offsetXTextField floatValue], originy + 19 + [offsetYTextField floatValue], sizewidth+100, sizeheight)];
	UIFont *font = self.duplexCalendarLabel.font;
	if([FontSizeTextField floatValue] == 0){
		self.duplexCalendarLabel.font = [font fontWithSize:16.0];
	}else{
		self.duplexCalendarLabel.font = [font fontWithSize:[FontSizeTextField floatValue]];
	}
	if(self.duplexCalendarLabel){
		if([self isDateHidden]){
			self.duplexCalendarLabel.hidden = true;
		}else{
			self.duplexCalendarLabel.hidden = false;
		}
	}

}

-(void)_updateLabels{
		%orig;
	[self layoutDuplexCalendarLabel];
	//if(!self.todayHeaderViewText){
		self.todayHeaderViewText = [stattodayHeaderView lunarDateHeaderString];
	//}
	self.duplexCalendarLabel.text = self.todayHeaderViewText;


	
}
-(void)_layoutDateLabel {	
	%orig;
	[self layoutDuplexCalendarLabel];
	_UILegibilityLabel *originalLegibilityLabel = MSHookIvar<_UILegibilityLabel *>(self, "_legibilityDateLabel");
	[originalLegibilityLabel setFrame:CGRectMake(originx, originy - 3, sizewidth, sizeheight)];
}
-(void)updateFormat{
	%orig;
	[self layoutDuplexCalendarLabel];
}
-(void)layoutSubviews {
	%orig;
	[self layoutDuplexCalendarLabel];
}


-(void)setDateHidden:(bool)arg1{
	%orig(arg1);

	if(self.duplexCalendarLabel){
		self.duplexCalendarLabel.hidden = arg1;
	}
}


%end

%hook SBFadeAnimationSettings

- (void)setDefaultValues {

%orig;

self.dateInSettings = nil;

}
%end

%ctor{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
								(void*)myObserver,
								savePressed,
								CFSTR("duplexcalendar.savepressed"),
								NULL,  
								CFNotificationSuspensionBehaviorDeliverImmediately);
	savePressed();
}
