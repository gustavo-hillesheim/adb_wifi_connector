import 'dart:convert';
import 'dart:io';

class ProcessRunner {
  Future<ProcessResult> run(String process,
      [List<String> arguments = const []]) {
    return Process.run(process, arguments, stdoutEncoding: utf8);
  }
}
