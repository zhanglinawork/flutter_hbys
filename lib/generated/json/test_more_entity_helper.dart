import 'package:flutter_hbys/test/product_item_entity.dart';
import 'package:flutter_hbys/test/test_more_entity.dart';

testMoreEntityFromJson(TestMoreEntity data, Map<String, dynamic> json) {
	if (json['current'] != null) {
		data.current = json['current']?.toString();
	}
	if (json['pages'] != null) {
		data.pages = json['pages']?.toString();
	}
	if (json['records'] != null) {
		data.records = new List<ProductItemEntity>();
		(json['records'] as List).forEach((v) {
			data.records.add(new ProductItemEntity().fromJson(v));
		});
	}
	if (json['size'] != null) {
		data.size = json['size']?.toString();
	}
	if (json['total'] != null) {
		data.total = json['total']?.toString();
	}
	return data;
}

Map<String, dynamic> testMoreEntityToJson(TestMoreEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['current'] = entity.current;
	data['pages'] = entity.pages;
	if (entity.records != null) {
		data['records'] =  entity.records.map((v) => v.toJson()).toList();
	}
	data['size'] = entity.size;
	data['total'] = entity.total;
	return data;
}