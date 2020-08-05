import 'dart:ui';

enum Priority {
  HIGH,
  NORMAL,
  LOW,
}

extension PriorityExtension on Priority {
  String get value => toString().split('.').last;

  Color get color {
    switch (this) {
      case Priority.HIGH:
        return const Color(0xFFFF2765);
      case Priority.NORMAL:
        return const Color(0xFF48CE00);
      case Priority.LOW:
        return const Color(0xFF4196EA);
      default:
        throw Exception('Missing color value for priority: $value');
    }
  }
}