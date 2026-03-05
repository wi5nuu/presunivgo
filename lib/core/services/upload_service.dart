import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_service.g.dart';

@riverpod
UploadService uploadService(UploadServiceRef ref) {
  return UploadService();
}

class UploadService {
  UploadService();

  /// Deprecated: We no longer use Firebase Storage
  Stream<double> uploadFileWithProgress({
    required File file,
    required String path,
  }) {
    return Stream.value(1.0);
  }

  /// Deprecated: We no longer use Firebase Storage
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    // Return a dummy URL or fallback
    return '';
  }
}
