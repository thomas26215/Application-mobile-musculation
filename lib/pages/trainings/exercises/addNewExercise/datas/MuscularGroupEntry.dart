class MuscularGroupEntry {
  String? name;
  String? value;

  MuscularGroupEntry({this.name, this.value});

  MuscularGroupEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }

  // Ajout de la méthode copyWith
  MuscularGroupEntry copyWith({String? name, String? value}) {
    return MuscularGroupEntry(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}

