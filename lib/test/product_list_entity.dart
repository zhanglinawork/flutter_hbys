

import 'package:flutter_hbys/generated/json/base/json_convert_content.dart';

import 'product_item_entity.dart';

class ProductListEntity with JsonConvert<ProductListEntity> {
	ProductListData data;
	String message;
	String nowTime;
	String state;
	String status;

}

class ProductListData with JsonConvert<ProductListData> {
	List<String> banners;
	List<ProductItemEntity> firstPageItems;
}

