package com.photoandvideo;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import static com.cjt2325.cameralibrary.JCameraView.BUTTON_STATE_BOTH;
import static com.cjt2325.cameralibrary.JCameraView.BUTTON_STATE_ONLY_CAPTURE;
import static com.cjt2325.cameralibrary.JCameraView.BUTTON_STATE_ONLY_RECORDER;


/**
 * This class echoes a string called from JavaScript.
 */
public class PhotoAndVideo extends CordovaPlugin {

  private CallbackContext callbackContext;
  private final int GET_PERMISSION_REQUEST = 0; //权限申请自定义码
  private int mediaQuality = BUTTON_STATE_BOTH;

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    this.callbackContext = callbackContext;
    if (action.equals("getVideosAndImage")) {
//            String message = args.getString(0);
      getPermissions();
      return true;
    }else if (action.equals("getImage")){
      mediaQuality = BUTTON_STATE_ONLY_CAPTURE;
      getPermissions();
      return true;
    }else if (action.equals("getVideos")){
      mediaQuality = BUTTON_STATE_ONLY_RECORDER;
      getPermissions();
      return true;
    }
    return false;
  }

  /**
   * 获取权限
   */
  private void getPermissions() {
//    String [] permissions = { Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO,  Manifest.permission.CAMERA};
//    cordova.requestPermissions(this, 0, permissions);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      if (cordova.hasPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) &&
        cordova.hasPermission(Manifest.permission.RECORD_AUDIO) &&
        cordova.hasPermission(Manifest.permission.CAMERA)) {
        Intent intent=new Intent(this.cordova.getActivity(),CameraActivity.class);
        intent.putExtra("mediaQuality",mediaQuality);
        this.cordova.startActivityForResult(this, intent, 0);
      } else {
        String [] permissions = { Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO,  Manifest.permission.CAMERA};
        cordova.requestPermissions(this, 0, permissions);
      }
    } else {
      Intent intent=new Intent(this.cordova.getActivity(),CameraActivity.class);
      intent.putExtra("mediaQuality",mediaQuality);
      this.cordova.startActivityForResult(this, intent, 0);
    }
  }

  @Override
  public void onRequestPermissionResult(int requestCode, String[] permissions,int[] grantResults) throws JSONException {
    super.onRequestPermissionResult(requestCode, permissions, grantResults);
    if (requestCode == GET_PERMISSION_REQUEST) {
      int size = 0;
      if (grantResults.length >= 1) {
        int writeResult = grantResults[0];
        //读写内存权限
        boolean writeGranted = writeResult == PackageManager.PERMISSION_GRANTED;//读写内存权限
        if (!writeGranted) {
          size++;
        }
        //录音权限
        int recordPermissionResult = grantResults[1];
        boolean recordPermissionGranted = recordPermissionResult == PackageManager.PERMISSION_GRANTED;
        if (!recordPermissionGranted) {
          size++;
        }
        //相机权限
        int cameraPermissionResult = grantResults[2];
        boolean cameraPermissionGranted = cameraPermissionResult == PackageManager.PERMISSION_GRANTED;
        if (!cameraPermissionGranted) {
          size++;
        }
        if (size == 0) {
          Intent intent=new Intent(this.cordova.getActivity(),CameraActivity.class);
          intent.putExtra("mediaQuality",mediaQuality);
          this.cordova.startActivityForResult(this, intent, 0);
        } else {
          this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
          return;
        }
      }
    }
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent intent) {
    super.onActivityResult(requestCode,resultCode,intent);
    if (resultCode == 101) {
      Log.i("CJT", "picture");
      String path = intent.getStringExtra("path");
      this.callbackContext.success("file://" + path);
    }
    if (resultCode == 102) {
      Log.i("CJT", "video");
      String path = intent.getStringExtra("path");
      this.callbackContext.success("file://" + path);
    }else {
      this.callbackContext.error("未知错误");
    }
  }
}
