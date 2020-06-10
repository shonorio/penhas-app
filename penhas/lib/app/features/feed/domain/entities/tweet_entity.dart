import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TweetEntity extends Equatable {
  final String id;
  final String userName;
  final int clientId;
  final String createdAt;
  final int totalReply;
  final int totalLikes;
  final bool anonymous;
  final String content;
  final String avatar;
  final TweetMeta meta;
  final List<TweetEntity> lastReply;

  TweetEntity({
    @required this.id,
    @required this.userName,
    @required this.clientId,
    @required this.createdAt,
    @required this.totalReply,
    @required this.totalLikes,
    @required this.anonymous,
    @required this.content,
    @required this.avatar,
    @required this.meta,
    this.lastReply,
  });

  @override
  List<Object> get props => [
        id,
        meta,
        avatar,
        content,
        userName,
        clientId,
        anonymous,
        createdAt,
        totalReply,
        totalLikes,
        lastReply,
      ];

  @override
  String toString() {
    return 'TweetEntity{id: ${id.toString()}, name: ${userName.toString()}, clientId: ${clientId.toString()}, createdAt: ${createdAt.toString()}, totalReply: ${totalReply.toString()}, totalLikes: ${totalLikes.toString()}, anonymous: ${anonymous.toString()}, content: ${content.toString()}, avatar: ${avatar.toString()}, meta: ${meta.toString()}, lastReplay: ${lastReply.toString()}}';
  }

  TweetEntity copyWith({
    String id,
    String userName,
    int clientId,
    String createdAt,
    int totalReply,
    int totalLikes,
    bool anonymous,
    String content,
    String avatar,
    TweetMeta meta,
    List<TweetEntity> lastReply,
  }) {
    return TweetEntity(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      clientId: clientId ?? this.clientId,
      createdAt: createdAt ?? this.createdAt,
      totalReply: totalReply ?? this.totalReply,
      totalLikes: totalLikes ?? this.totalLikes,
      anonymous: anonymous ?? this.anonymous,
      content: content ?? this.content,
      avatar: avatar ?? this.avatar,
      meta: meta ?? this.meta,
      lastReply: lastReply ?? this.lastReply,
    );
  }
}

class TweetMeta extends Equatable {
  final bool liked;
  final bool owner;

  TweetMeta({@required this.liked, @required this.owner});

  @override
  List<Object> get props => [liked, owner];

  @override
  String toString() {
    return 'TweetMeta {liked: ${liked.toString()}, owner: ${owner.toString()}}';
  }
}

class TweetGap extends TweetEntity {}