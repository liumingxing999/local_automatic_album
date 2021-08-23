# local_automatic_album
## local_automatic_album能做什么
`local_automatic_album` 是一个本地相册自动备份实时更新功能，您只需要打开自动备份功能，就会在您应用程序运行的情况下进行时间间隔备份到本地DB文件中。

当您有需要时，可以采用我们提供的获取DB文件数据方法，会返回给您所有数据。

本插件也会额外提供相册中Asset Id转化为base64功能，照片和视频都可以。

##### 本插件用于（列举以下三点）：

1.自动备份与其他后台运行APP插件联动可实现实时备份。

2.备份的数据获取后根据自己所需拼接后，通过其他插件传到前台，再通过前台传到操作数据库的后台实现动态备份上传到服务器数据。

3.通过使用手机网络判断插件，当无网时采用本地自动备份，有网时本地自动备份的同时，实行2操作即可实现动态备份。

> 如有反馈请加qq：2096099156    wx：WX2096099156

## 能力

- 手机相册自动备份到本地DB文件.

## 准备

#### Android

使用本插件需要修改一些配置，以便您正常运行

android/build.gradle

```gradle
buildscript {
	// 需要1.4.32版本
    ext.kotlin_version = '1.4.32'
    repositories {
        google()
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:4.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

android/build.gradle

```gradle
minSdkVersion 26    // 版本目前26为稳定版本 但是创建时自带的16是绝对不能运行
```

## 安装

使用安装依赖命令：

```shell
flutter pub add local_automatic_album
```

在`pubspec.yaml` 文件中添加local_automatic_album依赖:

```yaml
dependencies:
  local_automatic_album: ^0.0.1
```
## 使用

```dart
// 创建实例
AutomaticAlbum aublm = new AutomaticAlbum();

// 本地自动备份,备份间隔时间number建议是超过5秒钟（备份默认采用5秒更新）
// 成功：开启number秒备份成功
// 失败：1.请提供大于0的number参数间隔时间 2.报错信息
var openMessage = await aublm.automaticAlbum(number: 5); 

// 关闭正在进行的本地自动备份
// 成功：关闭成功
var closeMessage = await aublm.closeAutomaticAlbum();

// 默认获取本地自动备份的所有数据, 目前不提供多条查一次
// 成功：List<AssetEntity>数组（建议拿await接）
var allData = await aublm.getPhotoDataAll();
	// allData主要内容如下
    allData[0].id; // 相册某一照片资产ID也是assetId
    allData[0].relativePath; // 相对路径
    allData[0].thumbData; // 缩略数据
    allData[0].longitude; // 经度
    allData[0].latitude; // 纬度
    allData[0].type; // 类型：照片或视频
    allData[0].file; // 获取该照片或视频的文件类型
    allData[0].originFile; // 原文件
    allData[0].videoDuration; // 时长
    allData[0].modifiedDateTime; // 修改时间
    allData[0].createDateTime; // 创建时间
    allData[0].title; // 文件名
    allData[0].originBytes; // Uint8List

// 获取最后一次更新本地相册时间
// 成功：字符串类型 时间
// 失败：报错信息
var updateTime = await aublm.getLastPhotoUpdateTime();

// 清除本地DB的相册数据缓存（本函数谨慎使用）
// 此操作相当于删除表结构
// 会自动停住当前正在备份的automaticAlbum函数，但不会立即停，等本次备份执行完才会停。
// 成功：清除成功
// 失败：报错信息
var clearData = await aublm.clearCache();

// 传入相册的资产ID返回图片或者视频的base64
// 成功：base64值
// 失败：请传入正确并存在AssetEntity类型id
var base64Value = await aublm.getPhoto(allData[0].id);

// 传入相册的资产ID返回缩略图或缩略视频图的base64
// 成功：base64值
// 失败：请传入正确并存在AssetEntity类型id
var base64ThumValue = await aublm.getThumbnailPhoto(allData[0].id);


```

## 依赖

本插件依赖于:

[extended_image](https://pub.flutter-io.cn/packages/extended_image)、[photo_manager](https://pub.flutter-io.cn/packages/photo_manager)、[sqflite](https://pub.flutter-io.cn/packages/sqflite)

## QA

本人为开发插件新手，如有考虑不周或者代码上问题，欢迎您提问以及指教

如果能帮得上您，请您传播本插件，您的支持是我继续写下去的动力

qq：2096099156

wx：WX2096099156

## 作者
本人是一个将他人插件上复杂代码框架进行整理封装成某一功能的大学生（代码整理搬运工0.0）

感谢您的支持！

## LICENSE

    Copyright 2018 OpenFlutter Project
    
    Licensed to the Apache Software Foundation (ASF) under one or more contributor
    license agreements.  See the NOTICE file distributed with this work for
    additional information regarding copyright ownership.  The ASF licenses this
    file to you under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License.  You may obtain a copy of
    the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
    License for the specific language governing permissions and limitations under
    the License.





