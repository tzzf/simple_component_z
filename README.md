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
import 'package:simple_component_z/simple_button.dart';
```

```dart

SimpleButton(
    onTap: () => {print('点击')},
    child: Text('ZSimpleButton--》'),
),
```

| 参数            | 类型             |           描述     |
| :------------ |:---------------:| :-----|
| radius | double  | 圆角 |
| onTap | Function | 分页指示器与容器边框的距离 |
| child | Widget | 内部的控件 |
| elevation | double | 阴影"高度" |
| backgroundColor | Color | 背景颜色 |
| splashColor | Color | 点击的水波纹颜色 |
| onLongTap | Function | 长按回调 |


## picker Example
```dart
import 'package:simple_component_z/simple_picker.dart';
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
    new SimplePicker(
      selectItem: this._cityList,
      onConfirmFunc: handleConfirm,
    ).showModal(context);
  },
  child: new Text(this._cityVal != null && this._cityVal.length > 0 ?
    this._cityVal.join('') : '打开城市选择器' ),
  color: Colors.blue,
),
```
| 参数            | 类型             |           描述     |
| :------------ |:---------------:| :-----|
| selectItem | List  | 选择的内容 |
| onChangeFunc | PickerChangeCallback | 改变某列的回调函数 |
| onConfirmFunc | PickerConfirmCallback | 点击确定的回调函数 |

## upload Example
```dart
import 'package:simple_component_z/simple_upload.dart';

new SimpleUpload(
  takeWay: TakeWay.all,
  onSuccessFunc: (TakeWay type, File file) {
  },
).showModal(context);
```

| 参数            | 类型             |           描述     |
| :------------ |:---------------:| :-----|
| onSuccessFunc | PickerChangeCallback | 上传内容选择成功回调 必填 |
| labelStyle | TextStyle | 上传文案样式 |
| takeWay | TakeWay | 上传图片 视频 |


## ExpandText Example

```dart
import 'package:simple_component_z/expandtext_panel.dart';
String longText = '超过最大行数三行的多ewqe行文本超过\n最大行数\n三行\n的多行文本超过最大行数三行的多行文本'
      '超过最大行数三行的多行文本超过最大行数三行的多行43132文本超过最大行数三行的多行文本超过最大行数三行的多行文本';

ExpandTextPanel(
  text: longText,
  maxLines: 3,
  expandItem: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        '展开',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ],
  ),
  putawayItem: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        '收起',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ],
  ),
  style:
      TextStyle(fontSize: 26),
),
```

| 参数            | 类型             |           描述     |
| :------------ |:---------------:| :-----|
| text | String | 文本 |
| maxLines | int | 显示几行 |
| style | TextStyle | 文字样式 |
| isExpand | bool | 一开始是否展开  |
| expandItem | String/widget | 若是widget直接显示，展开部件  |
| putawayItem | String/widget | 若是widget直接显示，收起部件  |