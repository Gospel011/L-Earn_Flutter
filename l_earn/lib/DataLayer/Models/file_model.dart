class File {
  final String name;
  final String path;

  const File({required this.name, required this.path});

  @override
  String toString() {
    return 'File(name: $name, path: $path)';
  }
}
