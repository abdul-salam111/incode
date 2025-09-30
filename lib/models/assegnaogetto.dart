class ObjectTypeModel {
  final int idTypeObject;
  final String descriptionTypeObject;
  final List<AttributeModel> attributes;

  ObjectTypeModel({
    required this.idTypeObject,
    required this.descriptionTypeObject,
    required this.attributes,
  });

  factory ObjectTypeModel.fromJson(Map<String, dynamic> json) {
    return ObjectTypeModel(
      idTypeObject: json['id_type_object'] ?? 0,
      descriptionTypeObject: json['description_type_object'] ?? '',
      attributes: (json['attributes'] as List<dynamic>? ?? [])
          .map((e) => AttributeModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_type_object': idTypeObject,
      'description_type_object': descriptionTypeObject,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
  }
}

class AttributeModel {
  final int idAttribute;
  final String descriptionAttribute;
  final String typeAttribute;
  final bool required;
  final List<String> defaultValues;

  AttributeModel({
    required this.idAttribute,
    required this.descriptionAttribute,
    required this.typeAttribute,
    required this.required,
    required this.defaultValues,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(
      idAttribute: json['id_attribute'] ?? 0,
      descriptionAttribute: json['description_attribute'] ?? '',
      typeAttribute: json['type_attribute'] ?? '',
      required: json['required'] ?? false,
      defaultValues: (json['default_values'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_attribute': idAttribute,
      'description_attribute': descriptionAttribute,
      'type_attribute': typeAttribute,
      'required': required,
      'default_values': defaultValues,
    };
  }
}

