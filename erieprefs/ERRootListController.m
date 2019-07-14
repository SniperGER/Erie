#include "ERRootListController.h"
#include <spawn.h>

@implementation ERRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	
	prefBundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/erieprefs.bundle"];

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return ([settings objectForKey:specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
}

- (void)respring {
	BOOL isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_TITLE" value:@"" table:@"Root"]
																			 message:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_MESSAGE" value:@"" table:@"Root"]
																	  preferredStyle:isIpad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
	
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_CANCEL" value:@"" table:@"Root"]
														   style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:[prefBundle localizedStringForKey:@"RESTART_SPRINGBOARD_CONFIRM" value:@"" table:@"Root"]
															style:UIAlertActionStyleDestructive
														  handler:^(UIAlertAction* action) {
															  pid_t pid;
															  int status;
															  const char* args[] = {"killall", "-9", "SpringBoard", NULL};
															  posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
															  waitpid(pid, &status, WEXITED);
														  }];
	
	[alertController addAction:cancelAction];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end
