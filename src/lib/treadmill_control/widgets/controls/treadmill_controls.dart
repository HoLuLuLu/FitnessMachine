import 'package:fitness_machine/workout_management/services/workout_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TreadmillControls extends StatefulWidget {
  final WorkoutStateManager _workoutStateManager;

  TreadmillControls({super.key})
      : _workoutStateManager = GetIt.I<WorkoutStateManager>();

  @override
  TreadmillControlsState createState() => TreadmillControlsState();
}

class TreadmillControlsState extends State<TreadmillControls> {
  bool _isRunning = false;
  bool _isPaused = false;

  void _startOrPauseWorkout() {
    setState(() {
      if (!_isRunning) {
        _isRunning = true;
        _isPaused = false;
        widget._workoutStateManager.startWorkout();
      } else if (_isPaused) {
        _isPaused = false;
        widget._workoutStateManager.resumeWorkout();
      } else {
        _isPaused = true;
        widget._workoutStateManager.pauseWorkout();
      }
    });
  }

  void _stopWorkout() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      widget._workoutStateManager.stopWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startOrPauseWorkout,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: colorScheme.primary,
              ),
              child: Icon(
                _isRunning
                    ? (_isPaused ? Icons.play_arrow_outlined : Icons.pause)
                    : Icons.play_arrow,
                color: colorScheme.onPrimary,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _isRunning ? _stopWorkout : null,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: _isRunning
                    ? colorScheme.secondary
                    : colorScheme.secondary.withOpacity(0.5),
              ),
              child: Icon(
                Icons.stop,
                color: colorScheme.onSecondary,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
