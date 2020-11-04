
import 'exception_handler.dart';
import 'view_state_model.dart';

abstract class SingleViewStateModel<T> extends ViewStateModel{

  T data ;
  /// 分页第一页页码
  final int pageNumFirst = 1;

  /// 分页条目数量
  final int pageSize = 10;

  initData()async{
    setBusy(true);
    await fetchData(fetch: true);
  }

  fetchData({bool fetch = false})async{
    try{
      T temp = await loadData();
      if(temp == null){
        setEmpty();
      }else{
        onCompleted(temp);
        data = temp;
        if(fetch){
          setBusy(false);
        }else{
          notifyListeners();
        }
      }
    } catch (e,s){
      ExceptionHandler.getInstance().handleException(this, e, s);
      }
  }


  Future<T> loadData();

  onCompleted(T data);

}