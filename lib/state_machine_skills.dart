import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// An example showing how to drive a StateMachine via one numeric input.
class StateMachineSkills extends StatefulWidget {
  const StateMachineSkills({Key? key}) : super(key: key);

  @override
  State<StateMachineSkills> createState() => _StateMachineSkillsState();
}

class _StateMachineSkillsState extends State<StateMachineSkills> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? _levelInput;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    // skills.riv
    // skills_square.riv
    // icon_states.riv
    rootBundle.load('assets/icon_states (3).riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'sm_confidences');
        if (controller != null) {
          artboard.addController(controller);
          _levelInput = controller.findInput('level');
          print(
              "pkp:  ~ file: state_machine_skills.dart:43 ~ voidinitState ~ _levelInput");
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confidence Ring'),
      ),
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Stack(
                children: [
                  Positioned.fill(
                    child: Rive(
                      artboard: _riveArtboard!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    bottom: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: const Text('Beginner'),
                          onPressed: () => _levelInput?.value = 0,
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: const Text('Intermediate'),
                          onPressed: () => _levelInput?.value = 1,
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: const Text('Expert'),
                          onPressed: () => _levelInput?.value = 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
