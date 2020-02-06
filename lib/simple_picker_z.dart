import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PickerConfirmCallback = void Function(List selectedLabel, List<int> selectedVal);
typedef PickerChangeCallback = void Function(List selectedLabel, List<int> selectedVal, int selectItemIndex);


class ZSimplePicker {
  final List<List> selectItem;
  final PickerChangeCallback onChangeFunc;
  final PickerConfirmCallback onConfirmFunc;

  ZSimplePicker({
    this.selectItem,
    this.onConfirmFunc,
    this.onChangeFunc,
  });

  Widget _makePicker(BuildContext context) {
    return PickerScroll(
      contextList: selectItem,
      onConfirmFunc: onConfirmFunc,
      onChangeFunc: onChangeFunc,
    );
  }


  Future<T> showModal<T>(BuildContext ctx, [ThemeData themeData]) async {
    return await showModalBottomSheet<T>(
      context: ctx, //state.context,
      builder: (BuildContext context) {
        return _makePicker(context);
      },
    );
  }
}

class PickerScroll extends StatefulWidget {
  final List<List> contextList;
  final Function onChangeFunc;
  final Function onConfirmFunc;
  PickerScroll({Key key, this.contextList, this.onChangeFunc, this.onConfirmFunc}) : super(key: key);
  @override
  _PickerScrollState createState() => _PickerScrollState();
}

class _PickerScrollState extends State<PickerScroll> {
  //设置防抖周期为50ms
  Duration durationTime = Duration(milliseconds: 500);
  Timer timer;

  List<int> selectVal = [];
  List selectLabel = [];
  List<FixedExtentScrollController> _controller = [];

  Widget _pickerHeader(BuildContext ctx) {
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text('取消'),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: _handleConfirm,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text('确定'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleConfirm() {
    if (widget.onConfirmFunc != null) {
      widget.onConfirmFunc(this.selectLabel, this.selectVal);
    }
    Navigator.pop(context);
  }


  @override
  void initState() {
    super.initState();
    widget.contextList.forEach((f) {
      this.selectVal.add(0);
      this.selectLabel.add(f.length > 0 ? f[0] : '');
      this._controller.add(new FixedExtentScrollController());
    });
    setState(() {
    });
  }

  @override
  void dispose() {
    this._controller.forEach((f) {
      f?.dispose();
    });
    timer?.cancel();
    super.dispose();
  }

  void onChange(selectItemIndex, valueIndex) {
    this.selectVal[selectItemIndex] = valueIndex;
    this.selectLabel[selectItemIndex] = widget.contextList[selectItemIndex][valueIndex];
    if (widget.onChangeFunc != null) {
      timer?.cancel();
      timer = new Timer(durationTime, () {
        widget.onChangeFunc(this.selectLabel, this.selectVal, selectItemIndex);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 255,
      child: Column(
        children: <Widget>[
          _pickerHeader(context),
          Expanded(
            flex: 1,
            child: Row(
              children: List<Widget>.generate(
                widget.contextList.length,
                (int index) {
                  return Expanded(
                    flex: 1,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      scrollController: _controller[index],
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (value) {
                        // _index = value;
                        onChange(index, value);
                      },
                      children: List<Widget>.generate(widget.contextList[index].length, (int idx) {
                        return Text(widget.contextList[index][idx].toString());
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
