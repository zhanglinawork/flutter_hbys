// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `按住说话`
  String get voice_recoder_normal {
    return Intl.message(
      '按住说话',
      name: 'voice_recoder_normal',
      desc: '',
      args: [],
    );
  }

  /// `松开结束`
  String get voice_recorder_recording {
    return Intl.message(
      '松开结束',
      name: 'voice_recorder_recording',
      desc: '',
      args: [],
    );
  }

  /// `松开手指 取消发送`
  String get voice_recorder_want_cancel {
    return Intl.message(
      '松开手指 取消发送',
      name: 'voice_recorder_want_cancel',
      desc: '',
      args: [],
    );
  }

  /// `手指上滑 取消发送`
  String get voice_dialog_want_cancel {
    return Intl.message(
      '手指上滑 取消发送',
      name: 'voice_dialog_want_cancel',
      desc: '',
      args: [],
    );
  }

  /// `说话时间太短`
  String get voice_dialog_time_short {
    return Intl.message(
      '说话时间太短',
      name: 'voice_dialog_time_short',
      desc: '',
      args: [],
    );
  }

  /// `即将发送语音`
  String get voice_dialog_time_send {
    return Intl.message(
      '即将发送语音',
      name: 'voice_dialog_time_send',
      desc: '',
      args: [],
    );
  }

  /// `伙伴医生`
  String get appname {
    return Intl.message(
      '伙伴医生',
      name: 'appname',
      desc: '',
      args: [],
    );
  }

  /// `普通话`
  String get speech_title {
    return Intl.message(
      '普通话',
      name: 'speech_title',
      desc: '',
      args: [],
    );
  }

  /// `按住说话`
  String get speech_tip {
    return Intl.message(
      '按住说话',
      name: 'speech_tip',
      desc: '',
      args: [],
    );
  }

  /// `清空`
  String get speech_clear {
    return Intl.message(
      '清空',
      name: 'speech_clear',
      desc: '',
      args: [],
    );
  }

  /// `发送`
  String get speech_send {
    return Intl.message(
      '发送',
      name: 'speech_send',
      desc: '',
      args: [],
    );
  }

  /// `请说话…`
  String get speech_hint_text {
    return Intl.message(
      '请说话…',
      name: 'speech_hint_text',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}