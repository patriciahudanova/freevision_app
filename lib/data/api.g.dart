// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFormat _$MediaFormatFromJson(Map<String, dynamic> json) => MediaFormat(
      hash: json['hash'] as String,
      mime: json['mime'] as String,
      size: (json['size'] as num).toDouble(),
      url: json['url'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );

Map<String, dynamic> _$MediaFormatToJson(MediaFormat instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'mime': instance.mime,
      'size': instance.size,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

MediaFormats _$MediaFormatsFromJson(Map<String, dynamic> json) => MediaFormats(
      large: json['large'] == null
          ? null
          : MediaFormat.fromJson(json['large'] as Map<String, dynamic>),
      small: json['small'] == null
          ? null
          : MediaFormat.fromJson(json['small'] as Map<String, dynamic>),
      medium: json['medium'] == null
          ? null
          : MediaFormat.fromJson(json['medium'] as Map<String, dynamic>),
      thumbnail: json['thumbnail'] == null
          ? null
          : MediaFormat.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaFormatsToJson(MediaFormats instance) =>
    <String, dynamic>{
      'large': instance.large,
      'medium': instance.medium,
      'small': instance.small,
      'thumbnail': instance.thumbnail,
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: json['id'] as int,
      name: json['name'] as String,
      formats: MediaFormats.fromJson(json['formats'] as Map<String, dynamic>),
      hash: json['hash'] as String,
      mime: json['mime'] as String,
      size: (json['size'] as num).toDouble(),
      url: json['url'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'hash': instance.hash,
      'mime': instance.mime,
      'size': instance.size,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'id': instance.id,
      'name': instance.name,
      'formats': instance.formats,
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as int,
      title: json['title'] as String,
    )..image = json['image'] == null
        ? null
        : Media.fromJson(json['image'] as Map<String, dynamic>);

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _Api implements Api {
  _Api(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Story>> getStories({sort}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'_sort': sort};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(_setStreamType<List<Story>>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/stories',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Story.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
