import 'package:flutter_hbys/test/product_item_entity.dart';

productItemEntityFromJson(ProductItemEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['listThumb'] != null) {
		data.listThumb = json['listThumb']?.toString();
	}
	if (json['marketPrice'] != null) {
		data.marketPrice = json['marketPrice']?.toDouble();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toDouble();
	}
	if (json['productName'] != null) {
		data.productName = json['productName']?.toString();
	}
	if (json['productTypeId'] != null) {
		data.productTypeId = json['productTypeId'];
	}
	if (json['productTypeName'] != null) {
		data.productTypeName = json['productTypeName']?.toString();
	}
	if (json['sellingPoint'] != null) {
		data.sellingPoint = json['sellingPoint']?.toString();
	}
	if (json['singleOrPackage'] != null) {
		data.singleOrPackage = json['singleOrPackage']?.toInt();
	}
	if (json['version'] != null) {
		data.version = json['version']?.toString();
	}
	return data;
}

Map<String, dynamic> productItemEntityToJson(ProductItemEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['listThumb'] = entity.listThumb;
	data['marketPrice'] = entity.marketPrice;
	data['price'] = entity.price;
	data['productName'] = entity.productName;
	data['productTypeId'] = entity.productTypeId;
	data['productTypeName'] = entity.productTypeName;
	data['sellingPoint'] = entity.sellingPoint;
	data['singleOrPackage'] = entity.singleOrPackage;
	data['version'] = entity.version;
	return data;
}