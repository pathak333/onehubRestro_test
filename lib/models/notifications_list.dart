import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

List<RemoteMessage> remoteMessageListFromJson(String str) {
  if (str == null) return [];
  return List<RemoteMessage>.from(
      json.decode(str).map((x) => RemoteMessage.fromMap(x)));
}

String remoteMessageListToJson(List<RemoteMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) {
      RemoteMessageClone remoteMessageClone = RemoteMessageClone.fromMap(remoteMessagetoMap(x));
      return remoteMessageClone.toMap();
    })));

class RemoteMessageClone {
  final String senderId;

  final String category;

  final String collapseKey;

  final bool contentAvailable;

  final Map<String, dynamic> data;

  final String from;

  final String messageId;

  final String messageType;

  final bool mutableContent;

  final RemoteNotification notification;

  final DateTime sentTime;

  final String threadId;

  final int ttl;

  const RemoteMessageClone(
      {this.senderId,
      this.category,
      this.collapseKey,
      this.contentAvailable = false,
      this.data = const <String, dynamic>{},
      this.from,
      this.messageId,
      this.messageType,
      this.mutableContent = false,
      this.notification,
      this.sentTime,
      this.threadId,
      this.ttl});

  factory RemoteMessageClone.fromMap(Map<String, dynamic> map) {
    return RemoteMessageClone(
      senderId: map['senderId'],
      category: map['category'],
      collapseKey: map['collapseKey'],
      contentAvailable: map['contentAvailable'] ?? false,
      data: map['data'] == null
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(map['data']),
      from: map['from'],
      // Note: using toString on messageId as it can be an int or string when being sent from native.
      messageId: map['messageId']?.toString(),
      messageType: map['messageType'],
      mutableContent: map['mutableContent'] ?? false,
      notification: map['notification'] == null
          ? null
          : RemoteNotification.fromMap(
              Map<String, dynamic>.from(map['notification'])),
      // Note: using toString on sentTime as it can be an int or string when being sent from native.
      sentTime: map['sentTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['sentTime'].toString())),
      threadId: map['threadId'],
      ttl: map['ttl'],
    );
  }

  Map<String, dynamic> toMap() => {
        "senderId": senderId,
        "category": category,
        "collapseKey": collapseKey,
        "contentAvailable": contentAvailable,
        "data": data,
        "from": from,
        "messageId": messageId,
        "mutableContent": mutableContent,
        "notification": remoteNotificationtoMap(notification),
        "sentTime": sentTime.millisecondsSinceEpoch,
        "threadId": threadId,
        "ttl": ttl,
      };
}

Map<String, dynamic> remoteMessagetoMap(RemoteMessage message) => {
        "senderId": message.senderId,
        "category": message.category,
        "collapseKey": message.collapseKey,
        "contentAvailable": message.contentAvailable,
        "data": message.data,
        "from": message.from,
        "messageId": message.messageId,
        "mutableContent": message.mutableContent,
        "notification": remoteNotificationtoMap(message.notification),
        "sentTime": message.sentTime.millisecondsSinceEpoch,
        "threadId": message.threadId,
        "ttl": message.ttl,
      };

      Map<String, dynamic> remoteNotificationtoMap(RemoteNotification message) => {
        "title": message.title,
      "titleLocArgs": null,
      "titleLocKey": message.titleLocKey,
      "body": message.body,
      "bodyLocArgs": null,
      "bodyLocKey": message.bodyLocKey,
      "android": message.android == null ? null : androidNotificationtoMap(message.android),
      "apple": message.apple == null ? null : appleNotificationtoMap(message.apple),
      };

      Map<String, dynamic> androidNotificationtoMap(AndroidNotification notification) => {
        "channelId": notification.channelId,
        "clickAction": notification.clickAction,
        "color": notification.color,
        "count": notification.count,
        "imageUrl": notification.imageUrl,
        "link": notification.link,
        "priority": null,
        "smallIcon": notification.smallIcon,
        "sound": notification.sound,
        "ticker": notification.ticker,
        "tag": notification.tag,
        "visibility": null
      };

      Map<String, dynamic> appleNotificationtoMap(AppleNotification notification) => {
        "badge": notification.badge,
        "subtitle": notification.subtitle,
        "subtitleLocArgs": null,
        "subtitleLocKey": null,
        "imageUrl": notification.imageUrl,
        "sound": null
      };
