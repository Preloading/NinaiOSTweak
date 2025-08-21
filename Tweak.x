#import <Foundation/Foundation.h>
#import <execinfo.h>


%hook NSURL

+ (instancetype)URLWithString:(NSString *)URLString {
	// NSLog([NSString stringWithFormat:@"[AIM Patcher] Gotta go patch %@",URLString]);
	
	// Q: Why are we using this instead of stringByReplacingOccurrencesOfString only like older versions?
	// A: URLs can contain aol.com, and we have a high chance of breaking a URL like that

	// // Free debugging tools if you want that. This prints out the callstack. Useful!
	// if ([URLString isEqualToString:@"nina.chat"]) {
	// 	void *callstack[128];
	// 	int frames = backtrace(callstack, 128);
	// 	char **symbols = backtrace_symbols(callstack, frames);
	// 	// NSString *imlazy = @"a";
	// 	NSMutableString *callstackString = [NSMutableString stringWithFormat:@"[AIM Patcher] Callstack for modifying %@:\n", URLString];
	// 	for (int i = 0; i < frames; i++) {
	// 		[callstackString appendFormat:@"%s\n", symbols[i]];
	// 	}
	// 	NSLog(@"%@", callstackString);
		
	// 	free(symbols);
	// }

	NSURL *originalURL = %orig(URLString);
	if (!originalURL) {
		NSLog([NSString stringWithFormat:@"[NINA Patcher] Bad URL: %@", URLString]);
		return originalURL;
	}
	

	NSString *host = [originalURL host];
	if (!host) {
		NSLog([NSString stringWithFormat:@"[NINA Patcher] Bad URL: %@", URLString]);
		return originalURL;
	}

	NSString *newHost = nil;
	BOOL modifyHost = false;
	if ([host isEqualToString:@"api.aim.net"]) {
		newHost = @"api.nina.chat";
		modifyHost = true;
	} else if ([host isEqualToString:@"api.screenname.aol.com"]) {
		newHost = @"api.nina.chat";
		modifyHost = true;
	} else if ([host hasSuffix:@".aol.com"] && ![host isEqualToString:@"aol.com"])  {
		NSString *subdomain =  [host substringToIndex:[host length] - 8]; // remove AOL.com
		newHost = [subdomain stringByAppendingString:@".nina.bz"];
		modifyHost = true;
	} else if ([host isEqualToString:@"aol.com"]) {
		newHost = @"nina.bz";
		modifyHost = true;
	} else if ([host isEqualToString:@"icq.net"]) { // ICQ
		newHost = @"nina.bz";
		modifyHost = true;
	} else if ([host hasSuffix:@".icq.net"] && ![host isEqualToString:@"icq.net"])  {
		NSString *subdomain =  [host substringToIndex:[host length] - 8];
		newHost = [subdomain stringByAppendingString:@".nina.bz"];
		modifyHost = true;
	}

	if (!modifyHost) {
		return originalURL;
	}

	// and now for the fun bit, recreating!
	NSString *scheme = [originalURL scheme];
	NSString *path = [originalURL path];
	NSString *query = [originalURL query];

	NSMutableString *newURLString = [NSMutableString string];
	[newURLString appendFormat:@"%@://%@", scheme, newHost];

	// now for the extra params
	if (path && ![path isEqualToString:@""]) {
		[newURLString appendString:path];
	}

	if (query && ![query isEqualToString:@""]) {
		[newURLString appendFormat:@"?%@", query];
	}

	// NSLog([NSString stringWithFormat:@"[AIM Patcher] New URL: %@",newURLString]);

	return %orig(newURLString);
}

%end

// Disable the buggy analytics that like to cause a segfault.
%hook AOLMetricsDataLayerAgent
- (void)send:(id)param_3 parameters:(id)param_4 headers:(id)param_5 {
	// NSLog(@"[AIM Patcher] AOL analytics blocked!");
	return;
}
%end