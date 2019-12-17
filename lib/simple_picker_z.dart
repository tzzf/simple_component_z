import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './simple_button_z.dart';


class ZSimplePicker extends StatefulWidget {
  const ZSimplePicker({
    Key key,
    this.child,
    this.selectList,
    this.selectValue,
    this.okText,
    this.cancelText,
    this.onChange,
  }) : super(key: key);

  final onChange; // 但是ok按钮的回调
  final Widget child; // 点击这个组件显示picker
  final int selectValue; // 默认选中的索引
  final String okText; // ok按钮的文案
  final String cancelText; // 取消按钮的文案
  final List<Widget> selectList; // 可以选择的列表
  @override
  _ZSimplePickerState createState() => _ZSimplePickerState();
}

class _ZSimplePickerState extends State<ZSimplePicker> {
  FixedExtentScrollController _controller;
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = new FixedExtentScrollController();
  }

  jumpItem(int value) async {
    await Future.delayed(Duration( milliseconds: 100 ));
    _controller.jumpToItem(value);
  }

  @override
  Widget build(BuildContext context) {
    return ZSimpleButton(
      onTap: () => {
        openModel(context)
      },
      child: widget.child,
    );
  }

  openModel(BuildContext ctx) {
    if (widget.selectValue != null) {
      jumpItem(widget.selectValue);
    }
    selectedValue = widget.selectValue ?? 0;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: <Widget>[
              Spacer(),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(widget.cancelText ?? '取消'),
                    ),
                    FlatButton(
                      color: Colors.white,
                      onPressed: () {
                        if (widget.onChange != null) {
                          widget.onChange(selectedValue);
                        }
                        Navigator.pop(context);
                        // setState(() {
                        //   selectedGender = pickerChildren[selectedValue];
                        // });
                      },
                      child: Text(widget.okText ?? '确定'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  child: _buildGenderPicker(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderPicker() {
    return CupertinoPicker(
      itemExtent: 40,
      scrollController: _controller,
      backgroundColor: Colors.white,
      onSelectedItemChanged: (value) {
        selectedValue = value;
      },
      children: widget.selectList,
    );
  }
}
