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
    private static final String CHANNEL = "com.flutter.io/channel";
    private final String TAG = "permission";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getPublicDocumentsFolder"))  {
                                String folder = getPublicDocumentsFolder();
                                result.success(folder);
                            }
                            else
                            if (call.method.equals("getPublicDownloadsFolder"))  {
                                String folder = getPublicDownloadsFolder();
                                result.success(folder);
                            }
                            else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String getPublicDocumentsFolder() {
        File folder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
        String folderName = folder.getAbsolutePath();
        Log.d(TAG, "Downloads: " + folderName);
        return folderName;
    }

    private String getPublicDownloadsFolder() {
        File folder = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        String folderName = folder.getAbsolutePath();
        Log.d(TAG, "Downloads: " + folderName);
        return folderName;
    }


}


//import io.flutter.embedding.android.FlutterActivity;
//
//public class MainActivity extends FlutterActivity {
//}
