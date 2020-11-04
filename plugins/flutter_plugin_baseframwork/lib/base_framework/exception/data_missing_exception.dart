
import 'base_exception.dart';

/// data missing

class DataMissingException extends BaseException{
  DataMissingException({String message = "data missing"}) : super(message);

}