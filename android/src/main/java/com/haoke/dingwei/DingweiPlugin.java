package com.haoke.dingwei;

import android.Manifest;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AppComponentFactory;

import android.content.Context;


import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;


/** DingweiPlugin */
@RequiresApi(api = Build.VERSION_CODES.P)
public class DingweiPlugin extends AppComponentFactory implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener ,PluginRegistry.ActivityResultListener{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  //申请的权限
  private static final String[] mPermissions = {Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION
          ,Manifest.permission.READ_PHONE_STATE,Manifest.permission.WRITE_EXTERNAL_STORAGE};




   private MethodChannel channel;
   private EventChannel.EventSink eventSink  = null;
   private EventChannel.StreamHandler streamHandler = new EventChannel.StreamHandler() {
     @Override
     public void onListen(Object arguments, EventChannel.EventSink events) {

 //      Log.e(TAG, "onListen: " + events.toString());
       System.out.println("纬度======");
       eventSink = events;
         // map实例化
//         Map<Object, Object> maps = new HashMap<Object, Object>();
//         maps.put("eventid","1");
//         maps.put("data",new double[]{1,2});
//        eventSink.success(maps);
//         System.out.println("纬度=============");
         initLocation();
     }

     @Override
     public void onCancel(Object arguments) {
       eventSink = null;
     }
   };

    FlutterPluginBinding aa;



    Activity activity;

   @Override
   public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
     System.out.println("纬度====================");
     channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "dingwei");
     channel.setMethodCallHandler(this);
     EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "qy/eventChannel");
     eventChannel.setStreamHandler(streamHandler);





    aa = flutterPluginBinding;

   }









    @SuppressLint("ServiceCast")
    private void initLocation() {



        LocationManager locationManager =  (LocationManager) aa.getApplicationContext().getSystemService(aa.getApplicationContext().LOCATION_SERVICE);
        ///可以选择哪一个吧，虽然我也不知道写有没有用


        LocationListener listener = new LocationListener() {
            @Override
            public void onLocationChanged(Location location) {
                // 当GPS定位信息发生改变时，更新定位

                // map实例化
                Map<Object, Object> maps = new HashMap<Object, Object>();
                maps.put("eventid","1");
                maps.put("data",new double[]{location.getLatitude(),location.getLongitude()});
                eventSink.success(maps);
                System.out.println("纬度============="+location.getLatitude()+"经度============="+location.getLongitude());
            }
            @Override
            public void onStatusChanged(String provider, int status, Bundle extras) {
                System.out.println("status >>>>>>>>"+status);
            }

            @Override
            public void onProviderEnabled(String provider) {

            }
            @Override
            public void onProviderDisabled(String provider) {

            }
        };

        if(ContextCompat.checkSelfPermission(aa.getApplicationContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},1);

        } else {
            if(ContextCompat.checkSelfPermission(aa.getApplicationContext(), Manifest.permission.ACCESS_BACKGROUND_LOCATION) != PackageManager.PERMISSION_GRANTED){
                ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.ACCESS_BACKGROUND_LOCATION},1);
            }else{
                locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, listener);
                locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, listener);
                Location lastKnwonLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                if(lastKnwonLocation != null){
//                updateLocationInfo(lastKnwonLocation);
                }
            }
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, listener);
            locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, listener);
            Location lastKnwonLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            if(lastKnwonLocation != null){
//                updateLocationInfo(lastKnwonLocation);
            }
        }
    }
//    //数据更新
//    private List updateShow(Location location) {
//        if (location != null) {
//            StringBuilder sb = new StringBuilder();
//            list.clear();
//            list.add(location.getLongitude());
//            list.add(location.getLatitude());
//            return list;
//        }
//        return null;
//    }

   // 发送给flutter
   private Map sendEvent(String code, String[] obj) {
     Map<String, Object> map = new HashMap();
     map.put("eventid", code);
     if (obj != null) {
       map.put("data", obj);
     }
     return map;
   }
   @Override
   public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
     if (call.method.equals("getPlatformVersion")) {
       result.success("Android " + android.os.Build.VERSION.RELEASE);
     } else {
       result.notImplemented();
     }
   }

   @Override
   public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
     channel.setMethodCallHandler(null);
   }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity    =   binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }


    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        System.out.println("permissions======="+permissions.toString());
        return true;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        System.out.println("resultCode======="+resultCode);
        return true;
    }
}
