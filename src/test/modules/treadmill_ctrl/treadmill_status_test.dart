import 'package:flutter_test/flutter_test.dart';
import 'package:open_eqi_sports/modules/demo_ctrl/services/treadmill_status.dart';

void main() {
  group('Status parsing tests', () {
    test("Speed parsing 1kmh", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.speedInKmh, 1.0);
    });

    test("Speed parsing 3kmh", () {
      var data = [0x84, 0x24, 0x2C, 0x01, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.speedInKmh, 3.0);
    });

    test("Speed parsing 6kmh", () {
      var data = [0x84, 0x24, 0x58, 0x02, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.speedInKmh, 6.0);
    });

    test("Distance parsing 49m", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x31, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.distanceInKm, 0.049);
    });

    test("Distance parsing 100m", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x64, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.distanceInKm, 0.1);
    });

    test("Distance parsing 1km", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0xe8, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.distanceInKm, 1);
    });

    test("Distance parsing 10km", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x10, 0x27, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.distanceInKm, 10);
    });

    test("Calories parsing 2", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x20, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.indicatedCalories, 2);
    });

    test("Calories parsing 273", () {
      var data = [0x84, 0x24, 0x58, 0x02, 0x4e, 0x20, 0x00, 0x11, 0x01, 0xff, 0xff, 0xff, 0x52, 0x17, 0x17, 0x27, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.indicatedCalories, 273);
    });

    test("Time parsing 1s", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.timeInSeconds, 1);
    });

    test("Time parsing 60s", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x3c, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.timeInSeconds, 60);
    });

    test("Time parsing 300s", () {
      var data = [0x84, 0x24, 0x64, 0x00, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x38, 0x00, 0x00];
      var res = WorkoutStatus.fromBytes(data);
      expect(res.timeInSeconds, 300);
    });

    test("Long walk parsing:", () {
      var data = [0x84, 0x24, 0x58, 0x02, 0x4e, 0x20, 0x00, 0x11, 0x01, 0xff, 0xff, 0xff, 0x52, 0x17, 0x17, 0x27, 0x00];
      final expected = WorkoutStatus(speedInKmh: 6.0, distanceInKm: 8.27, indicatedCalories: 273, timeInSeconds: 5970, steps: 10007);

      var res = WorkoutStatus.fromBytes(data);
      expect(res.speedInKmh, expected.speedInKmh);
      expect(res.distanceInKm, expected.distanceInKm);
      expect(res.indicatedCalories, expected.indicatedCalories);
      expect(res.timeInSeconds, expected.timeInSeconds);
      expect(res.steps, expected.steps);
    });
  });
}
