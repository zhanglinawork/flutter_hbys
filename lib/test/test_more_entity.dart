import 'package:flutter_hbys/generated/json/base/json_convert_content.dart';
import 'product_item_entity.dart';

class TestMoreEntity with JsonConvert<TestMoreEntity> {
	String current;
	String pages;
	List<ProductItemEntity> records;
	String size;
	String total;
}
