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
      'uploadOptions': 'Upload options',
      'downloadLimit': 'Download limit',
      'unlimitedDownloads': 'Unlimited downloads',
      'expirationDate': 'Expiration date',
      'neverExpires': 'Never expires',
      'passwordProtection': 'Password protection',
      'optionalPassword': 'Optional password',
      'chooseDate': 'Choose date',
      'invalidDownloadLimit': 'Enter a download limit greater than zero.',
      'cancel': 'Cancel',
      'continue': 'Continue',
      'networkError': 'Network error',
      'deleteSuccess': 'File deleted',
      'deleteFailed': 'Delete failed',
      'loadFailed': 'Failed to load files',
      'unknownFile': 'Unknown',
      'downloadsLeft': 'Downloads left',
      'download': 'Download',
      'downloadSuccess': 'File saved',
      'downloadFailed': 'Could not download file',
      'downloadPermissionRequired': 'The API key needs DOWNLOAD permission.',
      'downloadUnsupportedEncryption':
          'End-to-end encrypted files are not supported.',
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
      'uploadOptions': 'Opzioni di caricamento',
      'downloadLimit': 'Limite di download',
      'unlimitedDownloads': 'Download illimitati',
      'expirationDate': 'Data di scadenza',
      'neverExpires': 'Non scade mai',
      'passwordProtection': 'Protezione con password',
      'optionalPassword': 'Password facoltativa',
      'chooseDate': 'Scegli data',
      'invalidDownloadLimit':
          'Inserisci un limite di download maggiore di zero.',
      'cancel': 'Annulla',
      'continue': 'Continua',
      'networkError': 'Errore di rete',
      'deleteSuccess': 'File eliminato',
      'deleteFailed': 'Eliminazione non riuscita',
      'loadFailed': 'Impossibile caricare i file',
      'unknownFile': 'Sconosciuto',
      'downloadsLeft': 'Download rimasti',
      'download': 'Scarica',
      'downloadSuccess': 'File salvato',
      'downloadFailed': 'Impossibile scaricare il file',
      'downloadPermissionRequired':
          'La chiave API deve avere il permesso DOWNLOAD.',
      'downloadUnsupportedEncryption':
          'I file con cifratura end-to-end non sono supportati.',
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
      'uploadOptions': 'Opciones de carga',
      'downloadLimit': 'Límite de descargas',
      'unlimitedDownloads': 'Descargas ilimitadas',
      'expirationDate': 'Fecha de caducidad',
      'neverExpires': 'No caduca nunca',
      'passwordProtection': 'Protección con contraseña',
      'optionalPassword': 'Contraseña opcional',
      'chooseDate': 'Elegir fecha',
      'invalidDownloadLimit':
          'Introduce un límite de descargas mayor que cero.',
      'cancel': 'Cancelar',
      'continue': 'Continuar',
      'networkError': 'Error de red',
      'deleteSuccess': 'Archivo eliminado',
      'deleteFailed': 'Error al eliminar',
      'loadFailed': 'No se pudieron cargar los archivos',
      'unknownFile': 'Desconocido',
      'downloadsLeft': 'Descargas restantes',
      'download': 'Descargar',
      'downloadSuccess': 'Archivo guardado',
      'downloadFailed': 'No se pudo descargar el archivo',
      'downloadPermissionRequired':
          'La clave API necesita el permiso DOWNLOAD.',
      'downloadUnsupportedEncryption':
          'No se admiten archivos cifrados de extremo a extremo.',
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
      'uploadOptions': 'Options d’envoi',
      'downloadLimit': 'Limite de téléchargements',
      'unlimitedDownloads': 'Téléchargements illimités',
      'expirationDate': 'Date d’expiration',
      'neverExpires': 'N’expire jamais',
      'passwordProtection': 'Protection par mot de passe',
      'optionalPassword': 'Mot de passe facultatif',
      'chooseDate': 'Choisir une date',
      'invalidDownloadLimit': 'Saisissez une limite supérieure à zéro.',
      'cancel': 'Annuler',
      'continue': 'Continuer',
      'networkError': 'Erreur réseau',
      'deleteSuccess': 'Fichier supprimé',
      'deleteFailed': 'Échec de la suppression',
      'loadFailed': 'Impossible de charger les fichiers',
      'unknownFile': 'Inconnu',
      'downloadsLeft': 'Téléchargements restants',
      'download': 'Télécharger',
      'downloadSuccess': 'Fichier enregistré',
      'downloadFailed': 'Impossible de télécharger le fichier',
      'downloadPermissionRequired':
          'La clé API doit disposer de la permission DOWNLOAD.',
      'downloadUnsupportedEncryption':
          'Les fichiers chiffrés de bout en bout ne sont pas pris en charge.',
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
      'uploadOptions': 'Upload-Optionen',
      'downloadLimit': 'Download-Limit',
      'unlimitedDownloads': 'Unbegrenzte Downloads',
      'expirationDate': 'Ablaufdatum',
      'neverExpires': 'Läuft nie ab',
      'passwordProtection': 'Passwortschutz',
      'optionalPassword': 'Optionales Passwort',
      'chooseDate': 'Datum auswählen',
      'invalidDownloadLimit': 'Gib ein Download-Limit größer als null ein.',
      'cancel': 'Abbrechen',
      'continue': 'Weiter',
      'networkError': 'Netzwerkfehler',
      'deleteSuccess': 'Datei gelöscht',
      'deleteFailed': 'Löschen fehlgeschlagen',
      'loadFailed': 'Dateien konnten nicht geladen werden',
      'unknownFile': 'Unbekannt',
      'downloadsLeft': 'Verbleibende Downloads',
      'download': 'Herunterladen',
      'downloadSuccess': 'Datei gespeichert',
      'downloadFailed': 'Datei konnte nicht heruntergeladen werden',
      'downloadPermissionRequired':
          'Der API-Schlüssel benötigt die Berechtigung DOWNLOAD.',
      'downloadUnsupportedEncryption':
          'Ende-zu-Ende-verschlüsselte Dateien werden nicht unterstützt.',
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
  String? _downloadingFileId;
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
      final options = await showDialog<UploadOptions>(
        context: context,
        builder: (_) => UploadOptionsDialog(language: _language),
      );
      if (options == null) return;

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
      request.fields['allowedDownloads'] =
          (options.downloadLimit ?? 0).toString();
      request.fields['expiryDays'] = (options.expiryDays ?? 0).toString();
      if (options.password.isNotEmpty) {
        request.fields['password'] = options.password;
      }

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

  Future<void> _downloadFile(
    String id,
    String name,
    Map<String, dynamic> file,
  ) async {
    if (!_hasConfig || id == 'N/A') return;
    if (file['RequiresClientSideDecryption'] == true ||
        file['IsEndToEndEncrypted'] == true) {
      _showError(_text('downloadUnsupportedEncryption'));
      return;
    }

    setState(() => _downloadingFileId = id);
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/files/download/${Uri.encodeComponent(id)}'),
        headers: {
          'apikey': _apiKey,
          'accept': '*/*',
          'increaseCounter': 'true',
        },
      );

      if (response.statusCode != 200) {
        _showError(
          response.statusCode == 401 || response.statusCode == 403
              ? _text('downloadPermissionRequired')
              : '${_text('downloadFailed')}: ${response.statusCode}',
        );
        return;
      }

      final savedFile = await FilePicker.saveFile(
        fileName: name,
        bytes: response.bodyBytes,
        mimeType:
            response.headers['content-type'] ?? 'application/octet-stream',
      );
      if (savedFile != null) _showSuccess(_text('downloadSuccess'));
    } catch (error) {
      _showError('${_text('downloadFailed')}: $error');
    } finally {
      if (mounted) setState(() => _downloadingFileId = null);
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
                        final fileName = (file['Name'] ??
                                file['name'] ??
                                _text('unknownFile'))
                            .toString();
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_downloadingFileId == fileId)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                IconButton(
                                  tooltip: _text('download'),
                                  icon: const Icon(Icons.download),
                                  onPressed: () => _downloadFile(
                                    fileId,
                                    fileName,
                                    Map<String, dynamic>.from(file),
                                  ),
                                ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteFile(fileId),
                              ),
                            ],
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

class UploadOptions {
  final int? downloadLimit;
  final int? expiryDays;
  final String password;

  const UploadOptions({
    required this.downloadLimit,
    required this.expiryDays,
    required this.password,
  });
}

class UploadOptionsDialog extends StatefulWidget {
  final String language;

  const UploadOptionsDialog({super.key, required this.language});

  @override
  State<UploadOptionsDialog> createState() => _UploadOptionsDialogState();
}

class _UploadOptionsDialogState extends State<UploadOptionsDialog> {
  late final TextEditingController _downloadLimitController;
  late final TextEditingController _passwordController;
  late final TextEditingController _expiryDateController;
  late DateTime _expiryDate;
  bool _unlimitedDownloads = false;
  bool _neverExpires = false;

  String _text(String key) => AppStrings.text(key, widget.language);

  @override
  void initState() {
    super.initState();
    _downloadLimitController = TextEditingController(text: '5');
    _passwordController = TextEditingController();
    _expiryDate =
        DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7)));
    _expiryDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateExpiryDateText();
  }

  @override
  void dispose() {
    _downloadLimitController.dispose();
    _passwordController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  void _updateExpiryDateText() {
    _expiryDateController.text = MaterialLocalizations.of(
      context,
    ).formatMediumDate(_expiryDate);
  }

  Future<void> _selectExpiryDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate.isAfter(today)
          ? _expiryDate
          : today.add(const Duration(days: 1)),
      firstDate: today.add(const Duration(days: 1)),
      lastDate: DateTime(today.year + 20),
    );
    if (selectedDate == null || !mounted) return;
    setState(() {
      _expiryDate = DateUtils.dateOnly(selectedDate);
      _updateExpiryDateText();
    });
  }

  void _submit() {
    final limit = int.tryParse(_downloadLimitController.text.trim());
    if (!_unlimitedDownloads && (limit == null || limit < 1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_text('invalidDownloadLimit'))),
      );
      return;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    final expiryDays = _neverExpires
        ? null
        : DateTime.utc(_expiryDate.year, _expiryDate.month, _expiryDate.day)
            .difference(DateTime.utc(today.year, today.month, today.day))
            .inDays;
    Navigator.of(context).pop(
      UploadOptions(
        downloadLimit: _unlimitedDownloads ? null : limit,
        expiryDays: expiryDays,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_text('uploadOptions')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_unlimitedDownloads) ...[
              TextField(
                controller: _downloadLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _text('downloadLimit'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_text('unlimitedDownloads')),
              value: _unlimitedDownloads,
              onChanged: (value) => setState(() => _unlimitedDownloads = value),
            ),
            if (!_neverExpires) ...[
              TextField(
                controller: _expiryDateController,
                readOnly: true,
                onTap: _selectExpiryDate,
                decoration: InputDecoration(
                  labelText: _text('expirationDate'),
                  suffixIcon: IconButton(
                    onPressed: _selectExpiryDate,
                    icon: const Icon(Icons.calendar_today),
                    tooltip: _text('chooseDate'),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_text('neverExpires')),
              value: _neverExpires,
              onChanged: (value) => setState(() => _neverExpires = value),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: _text('passwordProtection'),
                hintText: _text('optionalPassword'),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_text('cancel')),
        ),
        FilledButton(onPressed: _submit, child: Text(_text('continue'))),
      ],
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
