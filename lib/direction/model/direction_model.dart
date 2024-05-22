class Direction {
  String id;
  String direction;

  Direction({
    required this.id,
    required this.direction,
  });

  factory Direction.fromMap(Map<String, dynamic> data) {
    return Direction(
      id: data['ID'],
      direction: data['Direction'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Direction': direction,
    };
  }
}
