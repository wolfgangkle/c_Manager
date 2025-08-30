// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificateAdapter extends TypeAdapter<Certificate> {
  @override
  final int typeId = 0;

  @override
  Certificate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Certificate(
      title: fields[0] as String,
      expiry: fields[1] as DateTime,
      filePath: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      notifications: fields[4] as bool,
      issuer: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Certificate obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.expiry)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.notifications)
      ..writeByte(5)
      ..write(obj.issuer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
