import 'package:flutter_hbys/generated/json/base/json_convert_content.dart';

class ProductItemEntity with JsonConvert<ProductItemEntity> {
	String id;
	String listThumb;
	double marketPrice;
	double price;
	String productName;
	dynamic productTypeId;
	String productTypeName;
	String sellingPoint;
	int singleOrPackage;
	String version;
}
