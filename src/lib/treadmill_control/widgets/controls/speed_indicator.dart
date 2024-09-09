import 'package:fitness_machine/treadmill_control/models/speed_state.dart';
import 'package:fitness_machine/treadmill_control/widgets/cubits/speed_range_and_setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpeedIndicator extends StatelessWidget {
  const SpeedIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (ctx) => SpeedRangeAndSettingCubit(const SpeedState.zero()),
        child: BlocBuilder<SpeedRangeAndSettingCubit, SpeedState>(
          builder: (ctx, state) {
            final cubit = ctx.read<SpeedRangeAndSettingCubit>();
            return Card(
                child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () async => cubit.speedDown(),
                        child: const Icon(Icons.remove))),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Row(children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  state.speedInKmh.toStringAsFixed(1),
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ))),
                      ]),
                      Row(children: [
                        Expanded(
                            child: LinearProgressIndicator(
                                value: state.maxSpeed > 0
                                    ? (state.speedInKmh - state.minSpeed) /
                                        (state.maxSpeed - state.minSpeed)
                                    : 0))
                      ]),
                      Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(state.minSpeed.toStringAsFixed(1))),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text("km/h",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge))),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(state.maxSpeed.toStringAsFixed(1))),
                        ],
                      )
                    ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async => cubit.speedUp(),
                      child: const Icon(Icons.add)),
                ),
              ],
            ));
          },
        ));
  }
}
