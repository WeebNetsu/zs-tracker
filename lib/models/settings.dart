class SettingsModel {
  final List<int> availableRatingSystems = [5, 10];
  final List<String> availableThemes = ["Dark", "Light"];

  late int ratingSystem;
  late String theme;
  late DateTime? sendNotficationsAt;

  SettingsModel(this.ratingSystem, this.theme, this.sendNotficationsAt);

  /// Create a modal from JSON (Map) data
  SettingsModel.fromJSON(dynamic json)
      : this(
          json['ratingSystem'],
          json['theme'],
          json['sendNotifcationsAt'],
        );

  /// Convert model data to JSON format
  Map<String, dynamic> toJson() => {
        'ratingSystem': ratingSystem,
        'theme': theme,
        'sendNotifcationsAt': sendNotficationsAt?.toString(),
      };
}
