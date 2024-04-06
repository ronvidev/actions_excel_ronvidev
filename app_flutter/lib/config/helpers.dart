import 'dart:io';
import 'package:path/path.dart' as p;

Future<String> createFolder(String rutaCarpeta) async {
  if (Directory(rutaCarpeta).existsSync()) {
    return p.normalize(rutaCarpeta);
  } else {
    Directory nuevaCarpeta = await Directory(rutaCarpeta).create(recursive: true);
    return p.normalize(nuevaCarpeta.path);
  }
}