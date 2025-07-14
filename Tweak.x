#import <Foundation/Foundation.h>

%hook NSURL

+ (instancetype)URLWithString:(NSString *)URLString {
	NSString *modifiedURL = [URLString stringByReplacingOccurrencesOfString:@"api.aim.net" withString:@"api.nina.chat"];
	modifiedURL = [modifiedURL stringByReplacingOccurrencesOfString:@"api.screenname.aol.com" withString:@"api.nina.chat"];
	modifiedURL = [modifiedURL stringByReplacingOccurrencesOfString:@"aol.com" withString:@"nina.bz"];
	return %orig(modifiedURL);
}

%end
