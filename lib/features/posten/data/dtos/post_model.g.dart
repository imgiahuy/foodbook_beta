// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostContentDtoAdapter extends TypeAdapter<PostContentDto> {
  @override
  final int typeId = 0;

  @override
  PostContentDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostContentDto(
      username: fields[0] as String?,
      postid: fields[1] as String?,
      image: fields[2] as String?,
      recipe: fields[3] as String?,
      avatarUrl: fields[4] as String?,
      liked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PostContentDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.postid)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.recipe)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.liked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostContentDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
