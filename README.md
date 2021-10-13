# twitterinject
Returns `true` for all possible feature flags within the Twitter Mac app!

On Apple platforms, the default feature flags are present within three files:
- `fs_embedded_defaults_production.json`
- `fs_embedded_defaults_ipad_production.json`
- `fs_embedded_defaults_mac_production.json`

Keys look like the following:
```json
"_4dnl" : {
    "value" : false
}
```

These can vary from integer values, dictionary values, and Boolean values. (This limit isn't exhausted - there's quite a few.)

To find what a key represents, disassemble `T1Twitter.framework`. Search for xrefs to the key you're attempting to determine. You'll find their code typically represents the following:
```objc
@implementation TTACoreAnatomyFeatures
-(bool)isTFNReactionsPickerEnabled {
    TFSFeatureSwitches* switches = [self featureSwitches];
    return [switches boolForKey:@"_4dnl"];
}
@end
```

We can take advantage of the shared `TFSFeatureSwitches` logic and simply return true for all keys.

As of writing, this repository only returns false for `_k3i1` - an apparent feature switch for requesting notification access in the background. This fails on macOS and crashes the app.

Similarly (as of writing, with Twitter version 8.82), attempting to send voice DMs will fail as Twitter has not declared `NSSpeechRecognitionUsageDescription` and is killed by TCC.

---
# Building
SIP will *need* to be disabled for `DYLD_INSERT_LIBRARIES` to function properly. You can also `codesign --remove-signature /Applications/Twitter.app` and go from there, but the Twitter app may act oddly without various keychain credentials allowed. Use at your own risk.

Beyond that, `make run` and enjoy! You may find that at times the Twitter app will forcibly log you out when certain features are not enabled.