// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drafts_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftsAdapter extends TypeAdapter<Drafts> {
  @override
  final int typeId = 0;

  @override
  Drafts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drafts(
      id: fields[0] as String,
      bookName: fields[1] as String?,
      chapter: fields[2] as int?,
      title: fields[3] == null ? 'untitled' : fields[3] as String,
      content: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      dateLastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Drafts obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.chapter)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.dateLastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
