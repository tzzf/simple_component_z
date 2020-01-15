# simple_component_z

A new Flutter component package project.

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


## picker Example
```dart
import 'package:simple_component_z/simple_picker_z.dart';
```

```dart
List<List> _cityList = [['杭州', '北京', '上海', '大连']];

 List _cityVal;

void handleConfirm(List selectedLabel, List<int> selecteds) {
  setState(() {
    this._cityVal = selectedLabel;
  });
}

new FlatButton(
  onPressed: () {
    new ZSimplePicker(
      selectItem: this._cityList,
      onConfirmFunc: handleConfirm,
    ).showModal(context);
  },
  child: new Text(this._cityVal != null && this._cityVal.length > 0 ?
    this._cityVal.join('') : '打开城市选择器' ),
  color: Colors.blue,
),
```

final List<List> selectItem; // 选择的内容
final PickerCHangeCallback onChangeFunc; // 改变某列的回调函数
final PickerConfirmCallback onConfirmFunc; // 点击确定的回调函数

