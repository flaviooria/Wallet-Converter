class Settings {
  Settings({this.isFirstView, this.numberDigits, this.textStyle, this.theme});

  String? theme;
  String? textStyle;
  int? numberDigits;
  bool? isFirstView;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
      theme: json['theme'],
      textStyle: json['textStyle'],
      numberDigits: json['numberDigits'],
      isFirstView: json['isFirstView']);

  Map<String, dynamic> toJson() => {
        "theme": theme,
        "textStyle": textStyle,
        "numberDigits": numberDigits,
        "isFirstView": isFirstView
      };
}
