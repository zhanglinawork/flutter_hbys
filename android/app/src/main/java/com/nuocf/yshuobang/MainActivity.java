package com.nuocf.yshuobang;

import android.os.Bundle;

import com.nuocf.yshuobang.im.CustomizeMessage;
import com.nuocf.yshuobang.im.EndMessage;
import com.nuocf.yshuobang.im.PromptMessage;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.rong.imlib.AnnotationNotFoundException;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.MessageContent;


public class MainActivity extends FlutterActivity {

    static  String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.e(TAG,"初始化融云");
        RongIMClient.init( this,"cpj2xarlc14tn");
        List<Class<? extends MessageContent>> defineMsgType = new ArrayList<>();
        defineMsgType.add(PromptMessage.class);
        defineMsgType.add(CustomizeMessage.class);
        defineMsgType.add(EndMessage.class);
        try {
            Log.e(TAG,"注册自定义消息");
            RongIMClient.registerMessageType(defineMsgType);
//            RongIMClient.registerMessageType(PromptMessage.class);
//            RongIMClient.registerMessageType(CustomizeMessage.class);
            Log.e(TAG,"注册自定义消息1111");
        } catch (AnnotationNotFoundException e) {
            Log.e(TAG,"注册自定义消息--"+e.getMessage());
            e.printStackTrace();
        }

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

    }


}
