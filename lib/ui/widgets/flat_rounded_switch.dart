import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../SizeConfig.dart';
import '../blocks/switch_bloc.dart';
import '../events/switch_events.dart';
import '../interfaces/i_click.dart';
import '../states/switch_state.dart';

class FlatRoundedSwitch extends StatelessWidget implements IClick {
  final String uuid = const Uuid().v4().toString();

  final Color canvasColor;
  final Color iconColor;
  final Color borderColor;
  final Color canvasDisabledColor;
  final Color iconDisabledColor;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final IconData? T;
  final IconData? F;
  final VoidCallback? onAction;

  late GestureDetector gestureDetector;

  late SwitchBloc switchBloc;

  FlatRoundedSwitch({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
    this.borderWidth = 1,
    this.borderColor = Colors.black,
    this.canvasColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.canvasDisabledColor = Colors.black12,
    this.iconDisabledColor = Colors.black26,
    this.T = Icons.toggle_on_outlined,
    this.F = Icons.toggle_off_outlined,
    this.onAction,
  });

  @override
  void click() {
    gestureDetector.onTap?.call();
  }

  void reset() {
    try {
      switchBloc.add(Reset());
    } catch (exception) {
      debugPrint("******* reset error *******");
    }
  }

  void enable() {
    try {
      switchBloc.add(Enable());
    } catch (exception) {
      debugPrint("******* enable error *******");
    }
  }

  void disable() {
    try {
      switchBloc.add(Disable());
    } catch (exception) {
      debugPrint("******* disable error *******");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double? borderRadius_ = w_(borderRadius);
    double? borderWidth_ = w_(borderWidth);
    return BlocProvider<SwitchBloc>(
      //create: (_) => SwitchBloc(SwitchState(SwitchStates.off)),
      create: (_) {
        switchBloc = SwitchBloc(SwitchState(SwitchStates.off));
        return switchBloc;
      },
      child: BlocBuilder<SwitchBloc, SwitchState>(builder: (context, state) {
        gestureDetector = GestureDetector(
          onTap: () {
            context.read<SwitchBloc>().add(Click(uuid));
            onAction?.call();
          },
          child: Container(
            width: w_(width),
            height: h_(height),
            decoration: BoxDecoration(
              color: getCanvasColor(state.state()),
              borderRadius: BorderRadius.circular(borderRadius_!),
              border: Border.all(
                  color: getBorderColor(state.state()),
                  width: borderWidth_!),
            ),
            child: Center(
                child: Icon(getIcon(state.state()),
                    size: h_(height * 0.8),
                    color: getIconColor(state.state()))),
          ),
        );
        return gestureDetector;
      }),
    );
  }

  IconData? getIcon(SwitchStates state) {
    IconData? result = F;
    switch (state) {
      case SwitchStates.off:
      case SwitchStates.disabled_off:
        result = F;
        break;
      case SwitchStates.on:
      case SwitchStates.disabled_on:
        result = T;
        break;
      default:
    }
    return result;
  }

  Color? getIconColor(SwitchStates state) {
    Color? result = iconColor;
    switch (state) {
      case SwitchStates.off:
      case SwitchStates.on:
        result = iconColor;
        break;
      case SwitchStates.disabled_off:
      case SwitchStates.disabled_on:
        result = iconDisabledColor;
        break;
      default:
    }
    return result;
  }

  Color? getCanvasColor(SwitchStates state) {
    Color? result = canvasColor;
    switch (state) {
      case SwitchStates.off:
      case SwitchStates.on:
        result = canvasColor;
        break;
      case SwitchStates.disabled_off:
      case SwitchStates.disabled_on:
        result = canvasDisabledColor;
        break;
      default:
    }
    return result;
  }

  Color getBorderColor(SwitchStates state) {
    Color result = canvasColor;
    switch (state) {
      case SwitchStates.off:
      case SwitchStates.on:
        result = borderColor;
        break;
      case SwitchStates.disabled_off:
      case SwitchStates.disabled_on:
        result = canvasDisabledColor;
        break;
      default:
    }
    return result;
  }
}
