import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_service.g.dart';

@riverpod
UploadService uploadService(UploadServiceRef ref) {
  return UploadService(FirebaseStorage.instance);
}

class UploadService {
  final FirebaseStorage _storage;

  UploadService(this._storage);

  /// Uploads a file and returns a stream of the upload progress (0.0 to 1.0)
  Stream<double> uploadFileWithProgress({
    required File file,
    required String path,
  }) {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);

    return uploadTask.snapshotEvents.map((event) {
      if (event.totalBytes > 0) {
        return event.bytesTransferred / event.totalBytes;
      }
      return 0.0;
    });
  }

  /// Uploads a file and returns the download URL
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }
}
