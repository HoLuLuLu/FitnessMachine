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

class TreadmillControlsState extends State<TreadmillControls>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isLongPressing = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startOrPauseWorkout() {
    setState(() {
      if (!_isRunning) {
        _isRunning = true;
        _isPaused = false;
        widget._workoutStateManager.startWorkout();
      } else {
        if (_isPaused) {
          widget._workoutStateManager.resumeWorkout();
        } else {
          widget._workoutStateManager.pauseWorkout();
        }
        _isPaused = !_isPaused;
      }
    });
  }

  void _stopWorkout() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      widget._workoutStateManager.stopWorkout();
      _controller.reset(); // Fortschrittsanzeige zurücksetzen
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GestureDetector(
        onLongPressStart: (_) {
          _controller.forward(); // Animation starten
          _isLongPressing = true;
        },
        onLongPressEnd: (_) async {
          if (_controller.isCompleted) {
            _stopWorkout(); // Stopp bei vollständiger Animation (2 Sekunden)
          } else {
            _controller.reset(); // Reset, wenn nicht lang genug gedrückt
          }
          _isLongPressing = false;
        },
        onTap:
            _startOrPauseWorkout, // Normaler Tap startet oder pausiert das Workout
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fortschrittsring
            SizedBox(
              width: 120,
              height: 120,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _controller.value, // Fortschritt der Animation
                    strokeWidth: 8.0,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                  );
                },
              ),
            ),
            // Runde Schaltfläche
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _buildButtonIcon(colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonIcon(ColorScheme colorScheme) {
    return Container(
      key: ValueKey(_isRunning && !_isPaused),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: Center(
        child: Icon(
          _isRunning && !_isPaused ? Icons.pause : Icons.play_arrow,
          color: colorScheme.onPrimary,
          size: 50,
        ),
      ),
    );
  }
}
