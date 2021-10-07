import 'dart:io';

class ProcessRunner {
  run(String process, [List<String> arguments = const []]) {
    Process.run(process, arguments);
  }
}
