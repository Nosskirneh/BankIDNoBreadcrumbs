@interface BSSettings : NSObject
- (id)objectForSetting:(unsigned long long)setting;
@end

@interface BSMutableSettings : BSSettings
@end

@interface SBActivationSettings : NSObject {
    BSMutableSettings* _settings;
}
@end

@interface SBWorkspaceEntity : NSObject
@property (nonatomic, readonly) SBActivationSettings *activationSettings;
@end

@interface SBWorkspaceApplication : SBWorkspaceEntity
@property (nonatomic, retain, readonly) NSString *bundleIdentifier;
- (SBWorkspaceApplication *)workspaceApplication;
@end


%hook SBMainDisplaySceneManager

- (BOOL)_shouldBreadcrumbApplication:(SBWorkspaceApplication *)app withTransitionContext:(id)arg2 {
    SBActivationSettings *actSettings = [app workspaceApplication].activationSettings;
    if (actSettings) {
        BSSettings *bsSettings = MSHookIvar<id>(actSettings, "_settings");
        NSDictionary *launchOptions = [bsSettings objectForSetting:17];
        if (launchOptions) {
            NSString *sourceIdentifer = launchOptions[@"UIApplicationLaunchOptionsSourceApplicationKey"];
            if ([sourceIdentifer isEqualToString:@"com.bankidapp.BankID"]) {
                return NO;
            }
        }
    }

    return %orig;
}

%end
