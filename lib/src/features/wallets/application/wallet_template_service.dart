import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/wallet.dart';
import '../domain/wallet_template.dart';

/// Provider for managing imported wallet templates
/// Templates are stored locally and persist across app restarts
class WalletTemplateService {
  static const String _importedTemplatesKey = 'imported_wallet_templates';
  static const String _templatePacksKey = 'installed_template_packs';

  /// Get directory for storing imported icons
  static Future<Directory> getIconsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final iconsDir = Directory('${appDir.path}/wallet_icons');
    if (!await iconsDir.exists()) {
      await iconsDir.create(recursive: true);
    }
    return iconsDir;
  }

  /// Get all available templates (built-in + imported)
  /// 
  /// For development: returns built-in templates
  /// For release: returns only imported templates (after import)
  static Future<({List<WalletTemplate> banks, List<WalletTemplate> eWallets})> getTemplates({
    bool includeBuiltIn = true, // Set to false for release build
  }) async {
    final imported = await getImportedTemplates();
    
    if (includeBuiltIn) {
      // During development, show built-in templates
      // Add imported ones that don't conflict with built-in names
      final builtInNames = [...bankTemplates, ...eWalletTemplates].map((t) => t.name).toSet();
      final uniqueImported = imported.where((t) => !builtInNames.contains(t.name)).toList();
      
      return (
        banks: [...bankTemplates, ...uniqueImported.where((t) => t.type == WalletType.bank)],
        eWallets: [...eWalletTemplates, ...uniqueImported.where((t) => t.type == WalletType.ewallet)],
      );
    }
    
    // For release build, only show imported templates
    return (
      banks: imported.where((t) => t.type == WalletType.bank).toList(),
      eWallets: imported.where((t) => t.type == WalletType.ewallet).toList(),
    );
  }

  /// Get only imported templates (not built-in)
  static Future<List<WalletTemplate>> getImportedTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_importedTemplatesKey) ?? [];
      
      return jsonList.map((json) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return WalletTemplate(
          name: map['name'] as String,
          assetPath: map['assetPath'] as String,
          type: WalletType.values.firstWhere(
            (t) => t.name == map['type'],
            orElse: () => WalletType.other,
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading imported templates: $e');
      return [];
    }
  }

  /// Import templates from a ZIP file (icon pack)
  /// 
  /// ZIP structure:
  /// - manifest.json (required)
  /// - icon files (svg, png, jpg)
  static Future<ImportResult> importFromZip(File zipFile) async {
    try {
      // Read ZIP file
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // Find manifest.json
      ArchiveFile? manifestFile;
      for (final file in archive) {
        if (file.name.endsWith('manifest.json')) {
          manifestFile = file;
          break;
        }
      }
      
      if (manifestFile == null) {
        return ImportResult(
          success: false,
          packName: '',
          importedCount: 0,
          skippedCount: 0,
          error: 'manifest.json not found in ZIP file',
        );
      }
      
      // Parse manifest
      final manifestContent = utf8.decode(manifestFile.content as List<int>);
      final packData = jsonDecode(manifestContent) as Map<String, dynamic>;
      
      final packName = packData['packName'] as String? ?? 'Unknown Pack';
      final templatesData = packData['templates'] as List<dynamic>? ?? [];
      
      // Get icons directory
      final iconsDir = await getIconsDirectory();
      
      // Get existing templates to check for duplicates
      final prefs = await SharedPreferences.getInstance();
      final existingTemplates = await getImportedTemplates();
      final existingNames = existingTemplates.map((t) => t.name).toSet();
      
      final newTemplates = <WalletTemplate>[];
      int skipped = 0;
      
      for (var data in templatesData) {
        final name = data['name'] as String;
        final iconFileName = data['iconFileName'] as String;
        final typeStr = data['type'] as String;
        
        // Skip if already exists
        if (existingNames.contains(name)) {
          skipped++;
          continue;
        }
        
        // Find and extract icon file from ZIP
        ArchiveFile? iconFile;
        for (final file in archive) {
          if (file.name.endsWith(iconFileName)) {
            iconFile = file;
            break;
          }
        }
        
        if (iconFile == null) {
          debugPrint('Icon file not found: $iconFileName');
          skipped++;
          continue;
        }
        
        // Save icon to local storage
        final iconPath = '${iconsDir.path}/$iconFileName';
        final localIconFile = File(iconPath);
        await localIconFile.writeAsBytes(iconFile.content as List<int>);
        
        final type = switch (typeStr.toLowerCase()) {
          'bank' => WalletType.bank,
          'ewallet' || 'e-wallet' => WalletType.ewallet,
          'cash' => WalletType.cash,
          'creditcard' || 'credit_card' => WalletType.creditCard,
          'exchange' || 'investment' => WalletType.exchange,
          _ => WalletType.other,
        };
        
        newTemplates.add(WalletTemplate(
          name: name,
          assetPath: iconPath,
          type: type,
        ));
      }
      
      // Save templates to storage
      if (newTemplates.isNotEmpty) {
        final allTemplates = [...existingTemplates, ...newTemplates];
        final jsonList = allTemplates.map((t) => jsonEncode({
          'name': t.name,
          'assetPath': t.assetPath,
          'type': t.type.name,
        })).toList();
        
        await prefs.setStringList(_importedTemplatesKey, jsonList);
        
        // Track installed packs
        final installedPacks = prefs.getStringList(_templatePacksKey) ?? [];
        if (!installedPacks.contains(packName)) {
          installedPacks.add(packName);
          await prefs.setStringList(_templatePacksKey, installedPacks);
        }
      }
      
      return ImportResult(
        success: true,
        packName: packName,
        importedCount: newTemplates.length,
        skippedCount: skipped,
      );
    } catch (e) {
      debugPrint('Error importing ZIP pack: $e');
      return ImportResult(
        success: false,
        packName: '',
        importedCount: 0,
        skippedCount: 0,
        error: e.toString(),
      );
    }
  }

  /// Clear all imported templates and icons
  static Future<void> clearImportedTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_importedTemplatesKey);
    await prefs.remove(_templatePacksKey);
    
    // Also delete saved icons
    try {
      final iconsDir = await getIconsDirectory();
      if (await iconsDir.exists()) {
        await iconsDir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Error deleting icons directory: $e');
    }
  }

  /// Get list of installed packs
  static Future<List<String>> getInstalledPacks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_templatePacksKey) ?? [];
  }
  
  /// Check if any icon packs are installed
  static Future<bool> hasInstalledPacks() async {
    final packs = await getInstalledPacks();
    return packs.isNotEmpty;
  }
}

class ImportResult {
  final bool success;
  final String packName;
  final int importedCount;
  final int skippedCount;
  final String? error;

  ImportResult({
    required this.success,
    required this.packName,
    required this.importedCount,
    required this.skippedCount,
    this.error,
  });
}

/// Provider for imported templates
final importedTemplatesProvider = FutureProvider<List<WalletTemplate>>((ref) async {
  return WalletTemplateService.getImportedTemplates();
});

/// Provider for installed packs
final installedPacksProvider = FutureProvider<List<String>>((ref) async {
  return WalletTemplateService.getInstalledPacks();
});

/// Provider for all available templates (built-in + imported)
final availableTemplatesProvider = FutureProvider<({List<WalletTemplate> banks, List<WalletTemplate> eWallets})>((ref) async {
  // For development, include built-in templates
  // Change to false for Play Store release
  const bool isDevelopment = true; // TODO: Use kDebugMode or a build config
  return WalletTemplateService.getTemplates(includeBuiltIn: isDevelopment);
});

