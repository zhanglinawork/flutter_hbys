import 'package:flutter_hbys/test/product_item_entity.dart';
import 'package:flutter_hbys/test/product_list_entity.dart';

productListEntityFromJson(ProductListEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = new ProductListData().fromJson(json['data']);
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['nowTime'] != null) {
		data.nowTime = json['nowTime']?.toString();
	}
	if (json['state'] != null) {
		data.state = json['state']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	return data;
}

Map<String, dynamic> productListEntityToJson(ProductListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.data != null) {
		data['data'] = entity.data.toJson();
	}
	data['message'] = entity.message;
	data['nowTime'] = entity.nowTime;
	data['state'] = entity.state;
	data['status'] = entity.status;
	return data;
}

productListDataFromJson(ProductListData data, Map<String, dynamic> json) {
	if (json['banners'] != null) {
		data.banners = json['banners']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['firstPageItems'] != null) {
		data.firstPageItems = new List<ProductItemEntity>();
		(json['firstPageItems'] as List).forEach((v) {
			data.firstPageItems.add(new ProductItemEntity().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> productListDataToJson(ProductListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['banners'] = entity.banners;
	if (entity.firstPageItems != null) {
		data['firstPageItems'] =  entity.firstPageItems.map((v) => v.toJson()).toList();
	}
	return data;
}