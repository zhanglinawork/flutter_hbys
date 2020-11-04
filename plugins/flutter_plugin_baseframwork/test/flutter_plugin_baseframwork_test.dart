import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_plugin_baseframwork/flutter_plugin_baseframwork.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_plugin_baseframwork');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterPluginBaseframwork.platformVersion, '42');
  });
}
