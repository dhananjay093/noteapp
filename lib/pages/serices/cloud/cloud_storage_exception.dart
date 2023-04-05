class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateeNoteException extends CloudStorageException{}

class CouldNotGetAllNotesException extends CloudStorageException{}

class CouldNotUpdateNOteException extends CloudStorageException{}

class CouldNotDeleteNoteException extends CloudStorageException{}
