import 'base_state.dart';

/*
 *如果是view，继承 [WidgetState]
 *@author zln
 *create at 2020/10/27 下午6:06
 */
abstract class WidgetState extends BaseState with WidgetGenerator{

  ///刷新widget sate
  refreshState({Function task}){
    if(mounted){
      setState(task??() {

      });
    }
  }
}
























