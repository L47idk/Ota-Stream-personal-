import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/extension_model.dart';

final extensionManagerProvider = Provider((ref) => ExtensionManager());

class ExtensionManager {
  final Dio _dio = Dio();
  final String _repoIndexUrl =
      'https://raw.githubusercontent.com/otastream/extensions/main/index.json';

  List<ExtensionModel> _availableExtensions = [];
  List<ExtensionModel> _installedExtensions = [];

  List<ExtensionModel> get availableExtensions => _availableExtensions;
  List<ExtensionModel> get installedExtensions => _installedExtensions;

  // 1. Fetch remote index
  Future<void> fetchRemoteExtensions() async {
    try {
      final response = await _dio.get(_repoIndexUrl);
      if (response.statusCode == 200) {
        // Assume index.json is an array of objects
        final List<dynamic> data = json.decode(response.data);
        _availableExtensions = data.map((json) => ExtensionModel.fromJson(json)).toList();
        await _syncInstalledStatus();
      }
    } catch (e) {
      print('Error fetching extensions database: $e');
    }
  }

  // 2. Synchronize installed list by checking the local device Documents folder
  Future<void> _syncInstalledStatus() async {
    final dir = await getApplicationDocumentsDirectory();
    final extDir = Directory('${dir.path}/extensions');
    if (!await extDir.exists()) {
      await extDir.create(recursive: true);
    }

    _installedExtensions.clear();

    for (var ext in _availableExtensions) {
      final file = File('${extDir.path}/${ext.pkgName}.json');
      if (await file.exists()) {
        final installedExt = ext.copyWith(isInstalled: true);
        _installedExtensions.add(installedExt);

        // Update the item in the available list so UI shows 'Installed' status correctly
        final index = _availableExtensions.indexWhere((e) => e.pkgName == ext.pkgName);
        if (index != -1) {
          _availableExtensions[index] = installedExt;
        }
      }
    }
  }

  // 3. Download target script directly to storage
  Future<void> installExtension(ExtensionModel extension) async {
    try {
      final response = await _dio.get(extension.scriptUrl);
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/extensions/${extension.pkgName}.json');

        if (!await file.parent.exists()) {
          await file.parent.create(recursive: true);
        }
        // Write the logic JSON string directly locally
        await file.writeAsString(response.data);
        await _syncInstalledStatus();
      }
    } catch (e) {
      print('Install error: $e');
    }
  }

  // 4. Delete the script file from system storage
  Future<void> uninstallExtension(ExtensionModel extension) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/extensions/${extension.pkgName}.json');

      if (await file.exists()) {
        await file.delete();
        await _syncInstalledStatus(); // Syncs UI to show Install instead of Uninstall again
      }
    } catch (e) {
      print('Uninstall error: $e');
    }
  }

  // 5. Utility used by scraper to load script contents directly
  Future<String?> getExtensionScript(String pkgName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/extensions/$pkgName.json');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
       print('Read script error: $e');
    }
    return null;
  }
}