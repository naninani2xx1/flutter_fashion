// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReviewModel _$$_ReviewModelFromJson(Map<String, dynamic> json) =>
    _$_ReviewModel(
      id: json['id'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      product_id: json['product_id'] as int,
      star: json['star'] as int,
      content: json['content'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ReviewModelToJson(_$_ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'product_id': instance.product_id,
      'star': instance.star,
      'content': instance.content,
      'created_at': instance.created_at?.toIso8601String(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };
