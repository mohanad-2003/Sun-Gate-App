import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.condition,
    required super.status,
    required super.sellAs,
    required super.images,
    super.ownerCompanyId,
    super.isOwnedByCurrentUser,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      condition: json['condition']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sellAs: json['sellAs']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? const []),
      ownerCompanyId: _readOwnerCompanyId(json),
      isOwnedByCurrentUser: _readOwnershipFlag(json),
    );
  }

  static bool? _readOwnershipFlag(Map<String, dynamic> json) {
    return _readBool(json['isOwner']) ??
        _readBool(json['isOwned']) ??
        _readBool(json['isMine']) ??
        _readBool(json['canManage']) ??
        _readBool(json['canEdit']) ??
        _readBool(json['canUpdate']);
  }

  static String? _readOwnerCompanyId(Map<String, dynamic> json) {
    return _readId(json['companyId']) ??
        _readId(json['company']) ??
        _readId(json['sellerCompanyId']) ??
        _readId(json['sellerCompany']) ??
        _readId(json['ownerCompanyId']) ??
        _readId(json['ownerCompany']) ??
        _readId(json['seller']) ??
        _readId(json['owner']) ??
        _readId(json['createdBy']);
  }

  static String? _readId(dynamic value) {
    if (value == null) return null;

    if (value is String) return value;

    if (value is Map) {
      return value['_id']?.toString() ??
          value['id']?.toString() ??
          value['companyId']?.toString() ??
          _readId(value['company']);
    }

    return value.toString();
  }

  static bool? _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return null;
  }
}
