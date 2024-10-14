import 'package:json_annotation/json_annotation.dart';

part 'season.g.dart';

@JsonSerializable()
class Season {
	int? count;
	List<dynamic>? item;

	Season({this.count, this.item});

	factory Season.fromJson(Map<String, dynamic> json) {
		return _$SeasonFromJson(json);
	}

	Map<String, dynamic> toJson() => _$SeasonToJson(this);
}
