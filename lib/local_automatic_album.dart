library local_automatic_album;

import 'dart:async';
import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'SQLite.dart';
import 'Album.dart';
class AutomaticAlbum {

  /// 用于控制自动备份的开关，true为开，false为关
  static bool automaticState = false;

  /// 本地自动备份,备份间隔时间number建议是超过5秒钟（备份默认采用5秒更新）
  /// 成功：开启number秒备份成功
  /// 失败：1.请提供大于0的number参数间隔时间 2.报错信息
  Future<String> automaticAlbum ({int number = 5}) async {
    try {
      if (number > 0) {
        automaticState = true;
        var timeout = Duration(seconds: number);
        var timers = Timer.periodic(timeout, (timer) async {
          print(automaticState);
          // number s 回调一次
          var message = await findPhotos();
          print(message);
          if (automaticState == false) {
            timer.cancel();  // 取消定时器
          }
        });
        return "开启${number}秒自动备份";
      } else {
        return "请提供大于0的间隔时间";
      }
    } catch (e) {
      return e.toString();
    }
  }
  /// 关闭正在进行的本地自动备份
  /// 成功：关闭成功
  Future<String> closeAutomaticAlbum () async {
    automaticState = false;
    return "关闭成功";
  }
  /// 传入相册的资产ID返回图片或者视频的base64
  /// 成功： base64值
  /// 失败：请传入正确并存在AssetEntity类型id
  Future<String> getPhoto (String assetsId) async {
    try {
      var strAssetsId = assetsId.toString();
      var asset = await AssetEntity.fromId(strAssetsId);
      File? file= await asset!.file;
      List<int> fileCode = await file!.readAsBytes();
      var base64 = await base64Encode(fileCode);
      return base64;
    } catch (e) {
      return "请传入正确并存在AssetEntity类型id";
    }
  }
  /// 传入相册的资产ID返回缩略图或缩略视频图的base64
  /// 成功： base64值
  /// 失败：请传入正确并存在AssetEntity类型id
  Future<String> getThumbnailPhoto (String assetsId) async {
    try {
      var strAssetsId = assetsId.toString();
      var asset = await AssetEntity.fromId(strAssetsId);
      var assetList = await asset!.thumbData;
      List<int> fileCode = assetList!;
      var base64 = await base64Encode(fileCode);
      return base64;
    } catch (e) {
      return "请传入正确并存在AssetEntity类型id";
    }
  }

  /// 默认获取本地自动备份的所有数据, 目前不提供多条查一次，当您的相册照片过千，可能会消耗掉您1分钟左右时间才会返回值。
  /// 成功：List<AssetEntity>数组（建议拿await接）
  Future<List<AssetEntity>> getPhotoDataAll () async {
    await judgeTableCreate();
    List<AssetEntity> data = [];
    List<AssetPathEntity> albumList = await PhotoManager.getAssetPathList();
    var sel = await albumList[0].assetList;
    for(var i = 0;i < sel.length;i++){
      var selData = await RunSelect('select assetId from album where assetId = ${sel[i].id}');
      if (selData.length != 0) {
        var asset = await AssetEntity.fromId(selData[0].values.toList()[0]);
        data.add(asset!);
      }
    }
    return data;
  }
  /// 获取最后一次更新本地DB相册时间
  /// 成功：字符串类型 时间
  /// 失败：报错信息
  Future<String> getLastPhotoUpdateTime () async {
    try {
      await judgeTableCreate();
      var config = await RunSelect('select keyValue from Config where ablumKey = "LAST_ALBUM_CREATE"');
      return config[0].values.toList()[0].toString();
    } catch (e) {
      return e.toString();
    }
  }
  /// 清除本地DB的相册数据缓存（本函数谨慎使用）
  /// 此操作相当于删除表结构，会自动停住当前正在备份的automaticAlbum函数，但不会立即停，等本次备份执行完才会停。
  /// 成功：清除成功
  /// 失败：报错信息
  Future<String> clearCache () async {
    try {
      automaticState = false;
      await judgeTableCreate();
      await RunDelete('DROP TABLE album');
      await RunDelete('DROP TABLE Config');
      return "清除成功";
    } catch (e) {
      return e.toString();
    }
  }
}

