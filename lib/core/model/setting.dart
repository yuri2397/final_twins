import 'dart:convert';

class Setting {
  int? distanceInKilometers = 50;
  int? differenceInDays = 15;
  int? ageMin = 18;
  int? ageMax = 80;
  String? gender;

  Setting({
    this.distanceInKilometers = 50,
    this.differenceInDays = 15,
    this.ageMin = 18,
    this.ageMax = 80,
    this.gender,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        distanceInKilometers: json["distance_in_kilometers"] ?? 50,
        differenceInDays: json["difference_in_days"] ?? 15,
        ageMin: json["age_min"] ?? 18,
        ageMax: json["age_max"] ?? 80,
        gender: json["gender"] ?? 'both',
      );

  Map<String, dynamic> toJson() => {
        "distance_in_kilometers": distanceInKilometers,
        "difference_in_days": differenceInDays,
        "age_min": ageMin,
        "age_max": ageMax,
        "gender": gender,
      };
}
