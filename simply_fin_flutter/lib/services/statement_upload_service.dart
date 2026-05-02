import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_logger.dart';

enum UploadResult { success, duplicate, cancelled, error }

class StatementUploadService {
  final _supabase = Supabase.instance.client;

  Future<({UploadResult result, String? message})> pickAndUpload() async {
    appLogger.i('[Upload] Opening file picker...');

    // 1. Pick a PDF file
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (picked == null || picked.files.isEmpty) {
      appLogger.i('[Upload] User cancelled file selection.');
      return (result: UploadResult.cancelled, message: null);
    }

    final file = picked.files.first;
    final fileName = file.name;
    appLogger.i('[Upload] File selected: "$fileName"');

    // 2. Read bytes
    List<int> bytes;
    if (kIsWeb) {
      if (file.bytes == null) {
        appLogger.e('[Upload] Failed to read file bytes on web.');
        return (result: UploadResult.error, message: 'Could not read file.');
      }
      bytes = file.bytes!;
    } else {
      if (file.path == null) {
        appLogger.e('[Upload] File path is null on non-web platform.');
        return (
          result: UploadResult.error,
          message: 'Could not read file path.',
        );
      }
      bytes = await File(file.path!).readAsBytes();
    }
    appLogger.d(
      '[Upload] File size: ${(bytes.length / 1024).toStringAsFixed(1)} KB',
    );

    // 3. Compute SHA-256 hash
    final digest = sha256.convert(bytes);
    final fileHash = digest.toString();
    appLogger.d('[Upload] SHA-256: $fileHash');

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      appLogger.e('[Upload] No authenticated user found.');
      return (result: UploadResult.error, message: 'Not authenticated.');
    }

    // 4. Check for duplicate in DB
    appLogger.i('[Upload] Checking for duplicate in database...');
    final existing = await _supabase
        .from('uploaded_files')
        .select('id')
        .eq('user_id', userId)
        .eq('file_hash', fileHash)
        .maybeSingle();

    if (existing != null) {
      appLogger.w(
        '[Upload] Duplicate detected — file_hash already exists (id: ${existing['id']}).',
      );
      return (
        result: UploadResult.duplicate,
        message: 'This statement has already been uploaded.',
      );
    }
    appLogger.i('[Upload] No duplicate found. Proceeding with upload.');

    // 5. Upload to Supabase Storage: statements/{user_id}/{file_hash}.pdf
    final storagePath = 'statements/$userId/$fileHash.pdf';
    appLogger.i('[Upload] Uploading to storage path: "$storagePath"');
    await _supabase.storage
        .from('statements')
        .uploadBinary(
          storagePath,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(contentType: 'application/pdf'),
        );
    appLogger.i('[Upload] Storage upload complete.');

    // 6. Insert record into DB
    appLogger.i('[Upload] Inserting record into uploaded_files...');
    final insertedFile = await _supabase
        .from('uploaded_files')
        .insert({
          'user_id': userId,
          'file_hash': fileHash,
          'original_file_name': fileName,
          'processing_status': 'pending',
          'result_payload': null,
        })
        .select('id')
        .single();
    final fileId = insertedFile['id'] as String;
    appLogger.d('[Upload] uploaded_files record created (id: $fileId).');

    appLogger.i('[Upload] ✅ Done — "$fileName" uploaded successfully.');
    return (
      result: UploadResult.success,
      message: 'Statement uploaded successfully!',
    );
  }
}
