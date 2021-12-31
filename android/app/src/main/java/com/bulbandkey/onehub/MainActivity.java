package com.bulbandkey.onehubrestro;

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import android.content.ContentResolver;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.bulbandkey.onehubrestro/order_alerts_channel";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    // super.configureFlutterEngine(flutterEngine);
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
    //     .setMethodCallHandler((call, result) -> {
    //       if (call.method.equals("orderChannel")) {
    //         Boolean completed = createNotificationChannel();
    //         if (completed == true) {
    //           result.success(completed);
    //         } else {
    //           result.error("Error Code", "Error Message", null);
    //         }
    //       } else {
    //         result.notImplemented();
    //       }
    //     });
  }

  // private Boolean createNotificationChannel() {
  //   Boolean completed;
  //   if (VERSION.SDK_INT >= VERSION_CODES.O) {
  //     // Create the NotificationChannel
  //     String id = "order_alert_channel";
  //     String name = "order alert channel";
  //     String descriptionText = "order_alerts";
  //     String sound = "orderalert";
  //     int importance = NotificationManager.IMPORTANCE_HIGH;
  //     NotificationChannel mChannel = new NotificationChannel(id, name, importance);

  //     Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://"
  //         + getApplicationContext().getPackageName() + "/raw/orderalert");
  //     AudioAttributes att = new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_NOTIFICATION)
  //         .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build();

  //     mChannel.setSound(soundUri, att);
  //     // Register the channel with the system; you can't change the importance
  //     // or other notification behaviors after this
  //     NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
  //     notificationManager.createNotificationChannel(mChannel);
  //     completed = true;
  //   } else {
  //     completed = false;
  //   }
  //   return completed;
  // }
}
