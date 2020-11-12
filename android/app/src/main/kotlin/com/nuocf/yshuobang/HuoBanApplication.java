package com.nuocf.yshuobang;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Process;
import android.util.Log;
import java.util.Locale;
import java.util.Stack;

import androidx.multidex.MultiDex;
import io.flutter.app.FlutterApplication;



/**
 * Created by user on 2017/5/9.
 */

public class HuoBanApplication extends FlutterApplication {

    private String TAG = "HuoBanApplication";
    private static HuoBanApplication mApplication;
    //版本号
    private int versionCode;
    //版本名
    private String versionName;

    //防止升级窗口多次弹起
    public boolean hasVersionDialogShow = true;


    public static boolean LOGIN_RONG_SUCCESS;


    public String getVersionName() {
        getVersion();
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    //activity的栈
    public final Stack<Activity> mActivityStack = new Stack<Activity>();






    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        //解决分包在4.4出现闪退的问题
        MultiDex.install(base);
    }



    /**
     * 获取版本名和版本号
     */
    private void getVersion() {
        try {
            versionCode = getPackageManager().getPackageInfo(getPackageName(), 0).versionCode;
            versionName = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static HuoBanApplication getInstance() {
        return mApplication;
    }

}
