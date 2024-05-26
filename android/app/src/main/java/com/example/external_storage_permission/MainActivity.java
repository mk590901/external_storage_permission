package com.example.external_storage_permission;

import android.os.Bundle;
import android.os.BatteryManager;
import androidx.annotation.NonNull;

import android.os.Environment;
import android.util.Log;
import java.io.File;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.myapp/channel";
    private final String TAG = "permission";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();
                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            }
                            else
                            if (call.method.equals("getPath"))  {
                                //result.success("Test");
                                String folder = getPath();
                                result.success(folder/*"Test"*/);
                            }
                            else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private int getBatteryLevel() {
        BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        }
        return -1;
    }

    private String getPath() {
        File folder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
        String folderName = folder.getAbsolutePath();
        Log.d(TAG, "Downloads: " + folderName);
        return folderName;
    }


}


//import io.flutter.embedding.android.FlutterActivity;
//
//public class MainActivity extends FlutterActivity {
//}
