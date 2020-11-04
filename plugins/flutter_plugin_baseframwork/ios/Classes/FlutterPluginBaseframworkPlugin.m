#import "FlutterPluginBaseframworkPlugin.h"
#if __has_include(<flutter_plugin_baseframwork/flutter_plugin_baseframwork-Swift.h>)
#import <flutter_plugin_baseframwork/flutter_plugin_baseframwork-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_plugin_baseframwork-Swift.h"
#endif

@implementation FlutterPluginBaseframworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPluginBaseframworkPlugin registerWithRegistrar:registrar];
}
@end
