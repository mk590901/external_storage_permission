import '../../core/interfaces/i_transition_method.dart';

class OnNothing implements ITransitionMethod {
  @override
  void execute([var hashMap]) {
    print("@OnNothing $hashMap");
  }
}

class OnCheckPermission implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnCheckPermission $data");
    data?.call();
  }
}

class OnGranted implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnGranted $data");
    data?.call();
  }
}

class OnNoGranted implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnNoGranted $data");
  }
}

class OnDismiss implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnDismiss $data");
  }
}

class OnAllow implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnAllow $data");
  }
}

class OnFailed implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnFailed $data");
  }
}

class OnSuccess implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnSuccess $data");
    data?.call();
  }
}

class OnUp implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnUp $data");
  }
}

class OnDisableOff implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnDisableOff $data");
  }
}

class OnDisableOn implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnDisableOn $data");
  }
}

class OnEnableOff implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnEnableOff $data");
  }
}

class OnEnableOn implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnEnableOn $data");
  }
}

class OnDisable implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnDisable $data");
  }
}

class OnEnable implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnEnable $data");
  }
}

class OnPress implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnPress $data");
  }
}

class OnUnpress implements ITransitionMethod {
  @override
  void execute([var data]) {
    print("@OnUnpress $data");
  }
}

