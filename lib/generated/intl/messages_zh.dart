// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appname" : MessageLookupByLibrary.simpleMessage("伙伴医生"),
    "voice_dialog_time_send" : MessageLookupByLibrary.simpleMessage("即将发送语音"),
    "voice_dialog_time_short" : MessageLookupByLibrary.simpleMessage("说话时间太短"),
    "voice_dialog_want_cancel" : MessageLookupByLibrary.simpleMessage("手指上滑 取消发送"),
    "voice_recoder_normal" : MessageLookupByLibrary.simpleMessage("按住说话"),
    "voice_recorder_recording" : MessageLookupByLibrary.simpleMessage("松开结束"),
    "voice_recorder_want_cancel" : MessageLookupByLibrary.simpleMessage("松开手指 取消发送")
  };
}
