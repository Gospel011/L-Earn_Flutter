
/// This is a custom class for packaging the files for multi-part request
class File {

  /// This is the name of the file field that the backend would use in
  /// identifying which file is which.
  final String name;

  /// This is the location of the file in the internal storage
  final String path;

  const File({required this.name, required this.path});

  @override
  String toString() {
    return 'File(name: $name, path: $path)';
  }
}
