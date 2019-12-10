
package com.blockfolio;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import android.app.Activity;
import android.content.Intent;
import android.content.ComponentName;
import android.net.Uri;

import java.util.Arrays;

public class UniversalLinksModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String[] browserPackageNames = {"com.android.chrome", "org.mozilla.firefox", "com.UCMobile.intl", "com.sec.android.app.sbrowser", "com.opera.browser", "com.opera.mini.native", "com.microsoft.emmx"};

    public UniversalLinksModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "UniversalLinks";
    }

    @ReactMethod
    public void openURL(String url, Promise promise) {
        if (url == null || url.isEmpty()) {
            promise.reject(new JSApplicationIllegalArgumentException("Invalid URL: " + url));
            return;
        }

        boolean isExternalAppOpened = false;
        try {
            Uri uri = Uri.parse(url);
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(uri);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            ComponentName componentName = intent.resolveActivity(reactContext.getPackageManager());

            if (componentName != null && !Arrays.asList(browserPackageNames).contains(componentName.getPackageName())) {
                reactContext.startActivity(intent);
                isExternalAppOpened = true;
                promise.resolve(null);
            }
        } catch (Exception e) {
            promise.reject(new JSApplicationIllegalArgumentException(
                    "Could not open universal URL '" + url + "': " + e.getMessage()));
        }

        if (!isExternalAppOpened) {
            // couldn't open 3rd party app
            promise.reject(new JSApplicationIllegalArgumentException(
                    "No application to open, rejecting"));
        }
    }
}