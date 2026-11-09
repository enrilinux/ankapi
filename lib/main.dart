import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GokapiApp());
}

class GokapiConfig {
  static const _urlKey = 'gokapi_url';
  static const _apiKeyKey = 'gokapi_api_key';
  static const _languageKey = 'gokapi_language';
  static const _themeModeKey = 'ankapi_theme_mode';
  static const _materialYouKey = 'ankapi_material_you';

  final String url;
  final String apiKey;
  final String language;
  final String themeMode;
  final bool useMaterialYou;

  const GokapiConfig({
    this.url = '',
    this.apiKey = '',
    this.language = 'en',
    this.themeMode = 'system',
    this.useMaterialYou = true,
  });

  String get normalizedUrl => url.trim().replaceAll(RegExp(r'/+$'), '');

  String get normalizedLanguage =>
      AppStrings.supportedLanguages.contains(language) ? language : 'en';

  String get normalizedThemeMode =>
      const {'system', 'light', 'dark'}.contains(themeMode)
          ? themeMode
          : 'system';

  bool get isComplete => normalizedUrl.isNotEmpty && apiKey.trim().isNotEmpty;

  static Future<GokapiConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GokapiConfig(
      url: prefs.getString(_urlKey) ?? '',
      apiKey: prefs.getString(_apiKeyKey) ?? '',
      language: prefs.getString(_languageKey) ?? 'en',
      themeMode: prefs.getString(_themeModeKey) ?? 'system',
      useMaterialYou: prefs.getBool(_materialYouKey) ?? true,
    );
  }

  static Future<void> save({
    required String url,
    required String apiKey,
    required String language,
    required String themeMode,
    required bool useMaterialYou,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sanitizedUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
    final selectedLanguage =
        AppStrings.supportedLanguages.contains(language) ? language : 'en';
    final selectedThemeMode = const {'system', 'light', 'dark'}.contains(
      themeMode,
    )
        ? themeMode
        : 'system';

    await prefs.setString(_urlKey, sanitizedUrl);
    await prefs.setString(_apiKeyKey, apiKey.trim());
    await prefs.setString(_languageKey, selectedLanguage);
    await prefs.setString(_themeModeKey, selectedThemeMode);
    await prefs.setBool(_materialYouKey, useMaterialYou);
  }
}

class AppStrings {
  static const supportedLanguages = ['en', 'it', 'es', 'fr', 'de'];

  static const languageNames = {
    'en': 'English',
    'it': 'Italiano',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  static const _values = <String, Map<String, String>>{
    'en': {
      'homeTitle': 'Ankapi files',
      'missingConfig': 'Gokapi configuration is missing',
      'configure': 'Set URL and API key',
      'noFiles': 'No files found',
      'setConfigFirst': 'Set the URL and API key first.',
      'uploadSuccess': 'Upload successful',
      'uploadFailed': 'Upload failed',
      'networkError': 'Network error',
      'deleteSuccess': 'File deleted',
      'deleteFailed': 'Delete failed',
      'loadFailed': 'Failed to load files',
      'unknownFile': 'Unknown',
      'downloadsLeft': 'Downloads left',
      'settingsTitle': 'Ankapi settings',
      'language': 'Language',
      'themeMode': 'Appearance',
      'systemTheme': 'System default',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'designStyle': 'Design style',
      'normalStyle': 'Normal',
      'materialYouStyle': 'Material You',
      'gokapiUrl': 'Gokapi instance URL',
      'apiKey': 'API key',
      'requiredFields': 'URL and API key are required.',
      'saveSettings': 'Save settings',
    },
    'it': {
      'homeTitle': 'File Ankapi',
      'missingConfig': 'Configurazione Gokapi mancante',
      'configure': 'Imposta URL e API key',
      'noFiles': 'Nessun file trovato',
      'setConfigFirst': 'Configura prima URL e API key.',
      'uploadSuccess': 'Caricamento completato',
      'uploadFailed': 'Caricamento non riuscito',
      'networkError': 'Errore di rete',
      'deleteSuccess': 'File eliminato',
      'deleteFailed': 'Eliminazione non riuscita',
      'loadFailed': 'Impossibile caricare i file',
      'unknownFile': 'Sconosciuto',
      'downloadsLeft': 'Download rimasti',
      'settingsTitle': 'Impostazioni Ankapi',
      'language': 'Lingua',
      'themeMode': 'Aspetto',
      'systemTheme': 'Predefinito di sistema',
      'lightTheme': 'Chiaro',
      'darkTheme': 'Scuro',
      'designStyle': 'Stile grafico',
      'normalStyle': 'Normale',
      'materialYouStyle': 'Material You',
      'gokapiUrl': 'URL istanza Gokapi',
      'apiKey': 'API key',
      'requiredFields': 'URL e API key sono obbligatori.',
      'saveSettings': 'Salva impostazioni',
    },
    'es': {
      'homeTitle': 'Archivos de Ankapi',
      'missingConfig': 'Falta la configuración de Gokapi',
      'configure': 'Configurar URL y clave API',
      'noFiles': 'No se encontraron archivos',
      'setConfigFirst': 'Configura primero la URL y la clave API.',
      'uploadSuccess': 'Carga completada',
      'uploadFailed': 'Error al cargar',
      'networkError': 'Error de red',
      'deleteSuccess': 'Archivo eliminado',
      'deleteFailed': 'Error al eliminar',
      'loadFailed': 'No se pudieron cargar los archivos',
      'unknownFile': 'Desconocido',
      'downloadsLeft': 'Descargas restantes',
      'settingsTitle': 'Configuración de Ankapi',
      'language': 'Idioma',
      'themeMode': 'Apariencia',
      'systemTheme': 'Predeterminado del sistema',
      'lightTheme': 'Claro',
      'darkTheme': 'Oscuro',
      'designStyle': 'Estilo de diseño',
      'normalStyle': 'Normal',
      'materialYouStyle': 'Material You',
      'gokapiUrl': 'URL de la instancia Gokapi',
      'apiKey': 'Clave API',
      'requiredFields': 'La URL y la clave API son obligatorias.',
      'saveSettings': 'Guardar configuración',
    },
    'fr': {
      'homeTitle': 'Fichiers Ankapi',
      'missingConfig': 'La configuration Gokapi est manquante',
      'configure': 'Définir l’URL et la clé API',
      'noFiles': 'Aucun fichier trouvé',
      'setConfigFirst': 'Définissez d’abord l’URL et la clé API.',
      'uploadSuccess': 'Envoi réussi',
      'uploadFailed': 'Échec de l’envoi',
      'networkError': 'Erreur réseau',
      'deleteSuccess': 'Fichier supprimé',
      'deleteFailed': 'Échec de la suppression',
      'loadFailed': 'Impossible de charger les fichiers',
      'unknownFile': 'Inconnu',
      'downloadsLeft': 'Téléchargements restants',
      'settingsTitle': 'Paramètres Ankapi',
      'language': 'Langue',
      'themeMode': 'Apparence',
      'systemTheme': 'Thème du système',
      'lightTheme': 'Clair',
      'darkTheme': 'Sombre',
      'designStyle': 'Style visuel',
      'normalStyle': 'Classique',
      'materialYouStyle': 'Material You',
      'gokapiUrl': 'URL de l’instance Gokapi',
      'apiKey': 'Clé API',
      'requiredFields': 'L’URL et la clé API sont obligatoires.',
      'saveSettings': 'Enregistrer',
    },
    'de': {
      'homeTitle': 'Ankapi-Dateien',
      'missingConfig': 'Gokapi-Konfiguration fehlt',
      'configure': 'URL und API-Schlüssel festlegen',
      'noFiles': 'Keine Dateien gefunden',
      'setConfigFirst': 'Bitte zuerst URL und API-Schlüssel festlegen.',
      'uploadSuccess': 'Upload erfolgreich',
      'uploadFailed': 'Upload fehlgeschlagen',
      'networkError': 'Netzwerkfehler',
      'deleteSuccess': 'Datei gelöscht',
      'deleteFailed': 'Löschen fehlgeschlagen',
      'loadFailed': 'Dateien konnten nicht geladen werden',
      'unknownFile': 'Unbekannt',
      'downloadsLeft': 'Verbleibende Downloads',
      'settingsTitle': 'Ankapi-Einstellungen',
      'language': 'Sprache',
      'themeMode': 'Darstellung',
      'systemTheme': 'Systemstandard',
      'lightTheme': 'Hell',
      'darkTheme': 'Dunkel',
      'designStyle': 'Designstil',
      'normalStyle': 'Klassisch',
      'materialYouStyle': 'Material You',
      'gokapiUrl': 'URL der Gokapi-Instanz',
      'apiKey': 'API-Schlüssel',
      'requiredFields': 'URL und API-Schlüssel sind erforderlich.',
      'saveSettings': 'Einstellungen speichern',
    },
  };

  static String text(String key, String language) =>
      _values[language]?[key] ?? _values['en']![key]!;
}

class GokapiApp extends StatefulWidget {
  const GokapiApp({super.key});

  @override
  State<GokapiApp> createState() => _GokapiAppState();
}

class _GokapiAppState extends State<GokapiApp> {
  GokapiConfig _config = const GokapiConfig();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await GokapiConfig.load();
    if (mounted) setState(() => _config = config);
  }

  void _updateConfig(GokapiConfig config) {
    setState(() => _config = config);
  }

  ThemeMode get _themeMode => switch (_config.normalizedThemeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  ThemeData _createTheme(Brightness brightness, ColorScheme? dynamicScheme) {
    final scheme = _config.useMaterialYou && dynamicScheme != null
        ? dynamicScheme
        : ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: brightness,
          );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: _config.useMaterialYou,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'ankapi',
        debugShowCheckedModeBanner: false,
        theme: _createTheme(Brightness.light, lightDynamic),
        darkTheme: _createTheme(Brightness.dark, darkDynamic),
        themeMode: _themeMode,
        home: GokapiHomePage(onConfigChanged: _updateConfig),
      ),
    );
  }
}

class GokapiHomePage extends StatefulWidget {
  final ValueChanged<GokapiConfig> onConfigChanged;

  const GokapiHomePage({super.key, required this.onConfigChanged});

  @override
  State<GokapiHomePage> createState() => _GokapiHomePageState();
}

class _GokapiHomePageState extends State<GokapiHomePage> {
  List<dynamic> _files = [];
  bool _isLoading = false;
  bool _isCheckingConfig = true;
  String _baseUrl = '';
  String _apiKey = '';
  String _language = 'en';
  String _themeMode = 'system';
  bool _useMaterialYou = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  bool get _hasConfig =>
      _baseUrl.trim().isNotEmpty && _apiKey.trim().isNotEmpty;

  String _text(String key) => AppStrings.text(key, _language);

  String get _title => _text('homeTitle');
  String get _missingConfigText => _text('missingConfig');
  String get _missingConfigAction => _text('configure');
  String get _noFilesText => _text('noFiles');

  Future<void> _loadConfig() async {
    final config = await GokapiConfig.load();
    if (!mounted) return;

    setState(() {
      _baseUrl = config.normalizedUrl;
      _apiKey = config.apiKey.trim();
      _language = config.normalizedLanguage;
      _themeMode = config.normalizedThemeMode;
      _useMaterialYou = config.useMaterialYou;
      _isCheckingConfig = false;
    });
    widget.onConfigChanged(config);

    if (!_hasConfig) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openSettings();
      });
      return;
    }

    await _fetchFiles();
  }

  Future<void> _openSettings() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => GokapiSettingsPage(
          initialUrl: _baseUrl,
          initialApiKey: _apiKey,
          initialLanguage: _language,
          initialThemeMode: _themeMode,
          initialUseMaterialYou: _useMaterialYou,
        ),
      ),
    );

    if (result == true) {
      _loadConfig();
    }
  }

  Future<void> _fetchFiles() async {
    if (!_hasConfig) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/files/list'),
        headers: {'apikey': _apiKey, 'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final files = decoded is List ? decoded : <dynamic>[];
        debugPrint('Files: loaded ${files.length} item(s) from Gokapi.');
        setState(() => _files = files);
      } else {
        debugPrint('Files: Gokapi responded with HTTP ${response.statusCode}.');
        _showError('${_text('loadFailed')}: ${response.statusCode}');
      }
    } catch (e) {
      _showError('${_text('networkError')}: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _uploadFile() async {
    if (!_hasConfig) {
      _showError(_text('setConfigFirst'));
      _openSettings();
      return;
    }

    try {
      debugPrint('Upload: opening the Android file picker.');
      final file = await FilePicker.pickFile();
      if (file == null) {
        debugPrint('Upload: file selection cancelled.');
        return;
      }

      debugPrint('Upload: file selected; reading file length.');
      if (mounted) setState(() => _isLoading = true);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/files/add'),
      );
      request.headers['apikey'] = _apiKey;
      request.fields['allowedDownloads'] = '5';
      request.fields['expiryDays'] = '7';

      final fileLength = await file.length();
      debugPrint('Upload: file length is ${fileLength ?? 'unknown'} bytes.');
      request.files.add(
        fileLength != null
            ? http.MultipartFile(
                'file',
                file.readAsByteStream(),
                fileLength,
                filename: file.name,
              )
            : http.MultipartFile.fromBytes(
                'file',
                await file.readAsBytes(),
                filename: file.name,
              ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('Upload: Gokapi responded with HTTP ${response.statusCode}.');
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess(_text('uploadSuccess'));
        await _fetchFiles();
      } else {
        final responseDetails = response.body.length > 1000
            ? response.body.substring(0, 1000)
            : response.body;
        debugPrint('Upload: server response: $responseDetails');
        _showError(
          '${_text('uploadFailed')} (${response.statusCode}): ${response.body}',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Upload: ${error.runtimeType}: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showError('${_text('networkError')}: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteFile(String id) async {
    if (!_hasConfig) {
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/files/delete'),
        headers: {'apikey': _apiKey, 'id': id},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _showSuccess(_text('deleteSuccess'));
        await _fetchFiles();
      } else {
        _showError('${_text('deleteFailed')}: ${response.statusCode}');
      }
    } catch (e) {
      _showError('${_text('networkError')}: $e');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingConfig) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchFiles),
        ],
      ),
      body: !_hasConfig
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      _missingConfigText,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _openSettings,
                      child: Text(_missingConfigAction),
                    ),
                  ],
                ),
              ),
            )
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _files.isEmpty
                  ? Center(child: Text(_noFilesText))
                  : ListView.builder(
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        final fileName = file['Name'] ??
                            file['name'] ??
                            _text('unknownFile');
                        final fileId = file['Id']?.toString() ??
                            file['id']?.toString() ??
                            'N/A';
                        final downloadsLeft =
                            file['DownloadsRemaining']?.toString() ??
                                file['remainingDownloads']?.toString() ??
                                'N/A';

                        return ListTile(
                          leading: const Icon(Icons.file_present),
                          title: Text(fileName),
                          subtitle: Text(
                            'ID: $fileId | ${_text('downloadsLeft')}: $downloadsLeft',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFile(fileId),
                          ),
                        );
                      },
                    ),
      floatingActionButton: _hasConfig
          ? FloatingActionButton(
              onPressed: _uploadFile,
              child: const Icon(Icons.upload_file),
            )
          : null,
    );
  }
}

class GokapiSettingsPage extends StatefulWidget {
  final String initialUrl;
  final String initialApiKey;
  final String initialLanguage;
  final String initialThemeMode;
  final bool initialUseMaterialYou;

  const GokapiSettingsPage({
    super.key,
    required this.initialUrl,
    required this.initialApiKey,
    required this.initialLanguage,
    required this.initialThemeMode,
    required this.initialUseMaterialYou,
  });

  @override
  State<GokapiSettingsPage> createState() => _GokapiSettingsPageState();
}

class _GokapiSettingsPageState extends State<GokapiSettingsPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _apiKeyController;
  late String _selectedLanguage;
  late String _selectedThemeMode;
  late bool _useMaterialYou;

  String _text(String key) => AppStrings.text(key, _selectedLanguage);

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
    _apiKeyController = TextEditingController(text: widget.initialApiKey);
    _selectedLanguage = AppStrings.supportedLanguages.contains(
      widget.initialLanguage,
    )
        ? widget.initialLanguage
        : 'en';
    _selectedThemeMode = widget.initialThemeMode;
    _useMaterialYou = widget.initialUseMaterialYou;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final url = _urlController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (url.isEmpty || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_text('requiredFields')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await GokapiConfig.save(
      url: url,
      apiKey: apiKey,
      language: _selectedLanguage,
      themeMode: _selectedThemeMode,
      useMaterialYou: _useMaterialYou,
    );
    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_text('settingsTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: InputDecoration(
                labelText: _text('language'),
                border: const OutlineInputBorder(),
              ),
              items: AppStrings.languageNames.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedThemeMode,
              decoration: InputDecoration(
                labelText: _text('themeMode'),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(_text('systemTheme')),
                ),
                DropdownMenuItem(
                  value: 'light',
                  child: Text(_text('lightTheme')),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text(_text('darkTheme')),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedThemeMode = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<bool>(
              initialValue: _useMaterialYou,
              decoration: InputDecoration(
                labelText: _text('designStyle'),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: false,
                  child: Text(_text('normalStyle')),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text(_text('materialYouStyle')),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _useMaterialYou = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: _text('gokapiUrl'),
                hintText: 'https://gokapi.example.com',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: _text('apiKey'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: Text(_text('saveSettings')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
