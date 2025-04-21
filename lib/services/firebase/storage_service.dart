import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Bild hochladen
  Future<String> uploadImage(File file, String path) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final Reference ref = _storage.ref().child('$path/$fileName');
      
      // Bild hochladen
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask;
      
      // Download-URL zurückgeben
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // Mehrere Bilder hochladen
  Future<List<String>> uploadMultipleImages(List<File> files, String path) async {
    try {
      List<String> downloadUrls = [];
      
      for (var file in files) {
        final url = await uploadImage(file, path);
        downloadUrls.add(url);
      }
      
      return downloadUrls;
    } catch (e) {
      print('Error uploading multiple images: $e');
      rethrow;
    }
  }

  // Web-Bilder hochladen (für Web-Plattform)
  Future<String> uploadImageWeb(Uint8List bytes, String path, String fileName) async {
    try {
      final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final Reference ref = _storage.ref().child('$path/$uniqueFileName');
      
      // Bild hochladen
      final UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot taskSnapshot = await uploadTask;
      
      // Download-URL zurückgeben
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading web image: $e');
      rethrow;
    }
  }

  // Datei herunterladen
  Future<File> downloadFile(String downloadUrl, String localPath) async {
    try {
      final File file = File(localPath);
      
      // Reference von URL erstellen
      final ref = _storage.refFromURL(downloadUrl);
      
      // Datei herunterladen
      final DownloadTask downloadTask = ref.writeToFile(file);
      await downloadTask;
      
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }

  // Datei löschen
  Future<void> deleteFile(String downloadUrl) async {
    try {
      // Reference von URL erstellen
      final ref = _storage.refFromURL(downloadUrl);
      
      // Datei löschen
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  // Mehrere Dateien löschen
  Future<void> deleteMultipleFiles(List<String> downloadUrls) async {
    try {
      for (var url in downloadUrls) {
        await deleteFile(url);
      }
    } catch (e) {
      print('Error deleting multiple files: $e');
      rethrow;
    }
  }

  // Temporäre Download-URL mit begrenzter Gültigkeit erstellen
  Future<String> getTemporaryDownloadUrl(String path, {int validityDuration = 3600}) async {
    try {
      final ref = _storage.ref().child(path);
      
      // Download-URL mit begrenzter Gültigkeit generieren
      final String url = await ref.getDownloadURL();
      
      return url;
    } catch (e) {
      print('Error getting temporary download URL: $e');
      rethrow;
    }
  }
}