# simple_component_z

A new Flutter package project.

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


## 可点击按钮 Example

```dart
import 'package:simple_component_z/simple_button_z.dart';
```

```dart

ZSimpleButton(
    onTap: () => {print('点击')},
    child: Text('ZSimpleButton--》'),
),
```

可传参数
final double radius; //圆角
final Function onTap; //点击回调
final Widget child; // 内部的控件
final double elevation; //阴影"高度"
final Color backgroundColor; //背景颜色
final Color splashColor; // 点击的水波纹颜色
final Function onLongTap;  //长按回调


## 单列picker Example
```dart
import 'package:simple_component_z/simple_picker_z.dart';
```

```dart
class ShowList {
  dynamic value;
  String name;

  ShowList.fromJson(Map json){
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }

}
final List<ShowList> _sexList = []..addAll([
    ShowList.fromJson({'name': '男', 'value': 1}),
    ShowList.fromJson({'name': '女', 'value': 0})
]);
int _sexVal;

void handleChangeSex(val) {
    setState(() {
      this._sexVal = val;
    });
}


ZSimplePicker(
    selectList: _sexList.map((data) {
        return Text(data.name ?? '');
    }).toList(),
    selectValue: _sexVal,
    onChange: handleChangeSex,
    child: Text(_sexVal != null ? _sexList[_sexVal].name : '打开性别选择器'),
),
```

final onChange; // 但是ok按钮的回调
final Widget child; // 点击这个组件显示picker
final int selectValue; // 默认选中的索引
final String okText; // ok按钮的文案
final String cancelText; // 取消按钮的文案
final List<Widget> selectList; // 可以选择的列表

