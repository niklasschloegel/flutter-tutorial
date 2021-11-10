import 'dart:io';

import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart" as syspaths;

class FsHelper {
  static Future<File> saveFile(File file) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
    return await file.copy("${appDir.path}/$fileName");
  }

  static Future<void> removeFile(File file) async {
    await file.delete();
  }
}
