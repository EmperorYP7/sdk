/// Holds a couple utility functions used at various places in the system.
library ddc.src.utils;

import 'dart:async' show Future;
import 'dart:io';

import 'package:analyzer/src/generated/element.dart';

/// Returns all libraries transitively imported or exported from [start].
List<LibraryElement> reachableLibraries(LibraryElement start) {
  var results = <LibraryElement>[];
  var seen = new Set();
  void find(LibraryElement lib) {
    if (seen.contains(lib)) return;
    seen.add(lib);
    results.add(lib);
    lib.importedLibraries.forEach(find);
    lib.exportedLibraries.forEach(find);
  }
  find(start);
  return results;
}

/// Returns an ANSII color escape sequence corresponding to [levelName]. Colors
/// are defined for: severe, error, warning, or info. Returns null if the level
/// name is not recognized.
String colorOf(String levelName) {
  levelName = levelName.toLowerCase();
  if (levelName == 'shout' || levelName == 'severe' || levelName == 'error') {
    return _RED_COLOR;
  }
  if (levelName == 'warning') return _MAGENTA_COLOR;
  if (levelName == 'info') return _CYAN_COLOR;
  return null;
}

const String _RED_COLOR = '\u001b[31m';
const String _MAGENTA_COLOR = '\u001b[35m';
const String _CYAN_COLOR = '\u001b[36m';

class OutWriter {
  IOSink _sink;
  int _indent = 0;
  String _prefix = "";
  bool newline = true;

  OutWriter(String path) {
    var file = new File(path);
    file.createSync();
    // TODO(jmesserly): not sure the async write here is worth the complexity.
    // It might be easier to just build a string and then write it to disk.
    _sink = file.openWrite();
  }

  void write(String string, [int indent = 0]) {
    if (indent < 0) inc(indent);
    var lines = string.split('\n');
    var length = lines.length;
    for (var i = 0; i < length - 1; ++i) {
      var prefix = (lines[i].isNotEmpty && (newline || i > 0)) ? _prefix : '';
      _sink.write('$prefix${lines[i]}\n');
    }
    var last = lines.last;
    if (last.isNotEmpty && (newline && length == 1 || length > 1)) {
      _sink.write(_prefix);
    }
    _sink.write(last);
    newline = string.isNotEmpty && last.isEmpty;
    if (indent > 0) inc(indent);
  }

  void inc([int n = 2]) {
    _indent = _indent + n;
    assert(_indent >= 0);
    _prefix = "".padRight(_indent);
  }

  void dec([int n = 2]) {
    _indent = _indent - n;
    assert(_indent >= 0);
    _prefix = "".padRight(_indent);
  }

  Future close() => _sink.close();
}
