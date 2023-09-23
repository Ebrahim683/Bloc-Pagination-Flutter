import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.g.dart';
part 'post_model.freezed.dart';

// ignore_for_file: invalid_annotation_target

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'body') String? body,
  }) = _PostModel;
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
