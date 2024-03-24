// ignore_for_file: avoid_print

void main() {
  final inputs = [
    (1.0, const Duration(hours: 1)),
    (1.5, const Duration(hours: 1, minutes: 30)),
    (13.5, const Duration(hours: 13, minutes: 30)),
  ];

  for (final input in inputs) {
    final raw = input.$1;
    final fine = Duration(hours: raw.floor(), minutes: (60 * (raw % 1)).toInt());

    if (input.$2 == fine) continue;
    print(fine);
  }

  for (final input in inputs) {
    final fine = input.$2;
    final raw = fine.inMinutes / 60;

    if (input.$1 == raw) continue;
    print(raw);
  }
}
