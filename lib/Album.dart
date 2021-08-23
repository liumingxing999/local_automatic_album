// 查找相册并将相册存放到本地DB文件
import 'package:photo_manager/photo_manager.dart';

import 'SQLite.dart';

/// 查找相册并将相册存放到本地DB文件
findPhotos () async {
  try {
    await judgeTableCreate();
    List<String> sql = [];
    var selList = await RunSelect('select keyValue from Config where ablumKey = "LAST_ALBUM_CREATE"');
    var dateTime = DateTime.parse(selList[0].values.toList()[0].toString());
    List<AssetPathEntity> lists = await PhotoManager.getAssetPathList();
    // for循环遍历所有相册，但大多数手机默认第一个相册为全部项目，剩下的所有加起来等于全部项目（但都是重复的）
    // 如果第一个不是全部项目请打开此处将await lists[0].assetList中0换成i即可
    // for(var i = 0;i < lists.length;i++){
      var ps = await lists[0].assetList;
      for(var j = 0;j < ps.length;j++){
        if (ps[j].createDateTime.difference(dateTime).inSeconds > 0) {
          sql.add("insert into album (assetId) values('${ps[j].id.toString()}');");
        }
      }
    // }
    sql.add("UPDATE Config SET keyValue = '${DateTime.now()}' WHERE ablumKey = 'LAST_ALBUM_CREATE'");
    await RunBatch(sql);
    return '操作成功';
  } catch (e) {
    return e.toString();
  }
}
/// 表存在判断
judgeTable (String tableName) async {
  try {
    List<Map> tbList = await RunSelect('select * from sqlite_master where type = "table" and name = "${tableName}"');
    if (tbList.toList().length == 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
/// 表判断创建
judgeTableCreate () async {
  if (await judgeTable('album')) {
    await RunSQL('CREATE TABLE album (assetId varchar2(20));');
  }
  if (await judgeTable('Config')) {
    List<String> conSql = [];
    conSql.add('DELETE FROM album');
    conSql.add('CREATE TABLE Config(ablumKey varchar2(255),keyValue varchar2(100),Description varchar2(64),Memo varchar2(64));');
    conSql.add("insert into Config (ablumKey,keyValue,Description,Memo) values('LAST_ALBUM_CREATE','2000-01-01 00:00:00.00','','');");
    await RunBatch(conSql);
  }
}