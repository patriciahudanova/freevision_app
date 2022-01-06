import 'package:dio/dio.dart';
import 'package:flutter_challenge/config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @GET("/stories")
  Future<List<Story>> getStories({@Query('_sort') String? sort});
}

@JsonSerializable()
class MediaFormat {
  String hash;
  String mime;
  double size;
  String url;
  int? width;
  int? height;

  MediaFormat({
    required this.hash,
    required this.mime,
    required this.size,
    required this.url,
    this.width,
    this.height,
  });

  factory MediaFormat.fromJson(Map<String, dynamic> json) =>
      _$MediaFormatFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFormatToJson(this);

  static String? getAbsoluteUrl(String? url) {
    if (url == null) {
      return null;
    }

    final uri = Uri.parse(url);
    if (uri.isAbsolute) {
      return uri.toString();
    }

    return Uri.parse("$kBaseUrl$url").toString();
  }
}

@JsonSerializable()
class MediaFormats {
  MediaFormat? large;
  MediaFormat? medium;
  MediaFormat? small;
  MediaFormat? thumbnail;

  MediaFormats({
    this.large,
    required this.small,
    required this.medium,
    required this.thumbnail,
  });

  factory MediaFormats.fromJson(Map<String, dynamic> json) =>
      _$MediaFormatsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFormatsToJson(this);
}

@JsonSerializable()
class Media extends MediaFormat {
  int id;
  String name;
  MediaFormats formats;

  Media({
    required this.id,
    required this.name,
    required this.formats,
    required String hash,
    required String mime,
    required double size,
    required String url,
    required int? width,
    required int? height,
  }) : super(
            hash: hash,
            mime: mime,
            size: size,
            url: url,
            width: width,
            height: height);

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

@JsonSerializable()
class Story {
  int id;
  String title;
  Media? image;

  Story({required this.id, required this.title});

  double? get aspectRatio {
    if (image == null || image!.width == null || image!.height == null) {
      return null;
    }
    return image!.height!.toDouble() / image!.width!.toDouble();
  }

  String? get thumbnailImageUrl =>
      image?.formats.small?.url ?? image?.formats.thumbnail?.url;

  String? get largestImageUrl =>
      image?.formats.large?.url ??
      image?.formats.medium?.url ??
      image?.formats.small?.url ??
      image?.formats.thumbnail?.url;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
