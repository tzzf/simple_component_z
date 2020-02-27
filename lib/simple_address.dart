import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///地址选择器
class SimpleAddressPicker extends StatefulWidget {
  // 回调函数
  final Function valueCb;

  // 获取省市区三个地址
  final Function getAllAdress;

  // 获取省市区单个地址信息
  final Function getOneAdress;

  // 默认值
  final Map<String, int> initValue;

  SimpleAddressPicker({
    Key key,
    @required this.valueCb,
    this.initValue,
    @required this.getOneAdress,
    @required this.getAllAdress,
  }) : super(key: key);

  @override
  _SimpleAddressPickertState createState() => new _SimpleAddressPickertState(initValue);
}

class _SimpleAddressPickertState extends State<SimpleAddressPicker> with SingleTickerProviderStateMixin {
  // 区域信息列表
  List<List> addressList;

  // 选择的省市县的名字
  String selectProvinceStr = '省份';
  String selectCityStr = '城市';
  String selectDistrictStr = '区/县';

  bool isLoading = false;

  // 当前Tab位置
  int currentTabPos = 0;

  TabController _tabController;

  Map<String, int> selectMap = new Map(); // 选中的值

  // Tab Text样式
  TextStyle tabTvStyle = new TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300);

  _SimpleAddressPickertState(initValue) {
    selectMap = initValue ?? {};
  }

  @override
  void initState() {
    super.initState();
    // 初始化控制器
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          // _checkTabCanSelect(_tabController.index);
          if (!_checkTabCanSelect(_tabController.index)) {
            if (selectMap['selectProvinceId'] < 0) {
              _tabController.animateTo(0);
            } else if (selectMap['selectCityId'] < 0) {
              _tabController.animateTo(1);
            }
          }
        }
      });

    if (selectMap.isEmpty) {
      // 给区域Id Map一个初始值
      selectMap['selectProvinceId'] = -1;
      selectMap['selectCityId'] = -1;
      selectMap['selectDistrictId'] = -1;

      // 第一次进来 这里调用我自己的接口 查询全国的所有省 可以替换成其他
      _queryLocal(1, 0);
    } else {
      _queryAllAdress();
    }
  }

  void _queryAllAdress() async {
    widget.getAllAdress(selectMap, (List provinceList, List cityList, List regioneList) {
      this.addressList = [provinceList, cityList, regioneList];
      selectProvinceStr = provinceList.firstWhere((f) => f['id'] ==  selectMap['selectProvinceId'], orElse: () => { 'name': null })['name'];
      selectCityStr = cityList.firstWhere((f) => f['id'] == selectMap['selectCityId'], orElse: () => { 'name': null })['name'];
      selectDistrictStr = regioneList.firstWhere((f) => f['id'] == selectMap['selectDistrictId'], orElse: () => { 'name': null })['name'];
      _tabController.animateTo(2);
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // 去掉左箭头
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.close,
                color: const Color(0xff666666),
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _getBody(),
    );
  }

  // 构建底部视图
  Widget _getBody() {
    if (_showLoadingDialog()) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Container(
        color: Colors.white,
        child: _buildContent(),
      );
    }
  }

  // 根据数据是否有返回显示加载条或者列表
  bool _showLoadingDialog() {
    if (addressList == null || addressList.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  ///有数据时构建tab和区域列表
  Widget _buildContent() {
    return new DefaultTabController(
      length: 3,
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 18.0)),
          Container(
            child: TabBar(
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: new Text(
                    '$selectProvinceStr',
                    style: tabTvStyle,
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: new Text(
                    '$selectCityStr',
                    style: tabTvStyle,
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: new Text(
                    '$selectDistrictStr',
                    style: tabTvStyle,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                _buildListView(0),
                _buildListView(1),
                _buildListView(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建列表
  Widget _buildListView(int inx) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: addressList[inx].length,
      itemBuilder: (BuildContext context, int positionIndex) {
        return _buildListRow(inx, positionIndex);
      },
    );
  }

  // 构建子项
  Widget _buildListRow(int listIndex, int positionIndex) {
    int id;
    if (listIndex == 0) {
      id = selectMap['selectProvinceId'];
    } else if (listIndex == 1) {
      id = selectMap['selectCityId'];
    } else {
      id = selectMap['selectDistrictId'];
    }
    return new ListTile(
      title: new Text(
        '${addressList[listIndex][positionIndex]['name']}',
        style: new TextStyle(
          color: addressList[listIndex][positionIndex]['id'] == id ? Color(0xff3997F3) : Color(0xff666666),
          fontSize: 15.0,
        ),
      ),
      onTap: () => _onLocalSelect(listIndex, positionIndex),
    );
  }

  // 区域位置选择
  _onLocalSelect(int listIndex, int positionIndex) {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    _setSelectData(listIndex, positionIndex);
    if (listIndex < 2) {
      _tabController.animateTo(listIndex + 1);
      _queryLocal(addressList[listIndex][positionIndex]['id'], listIndex + 1);
    }
  }

  // 设置选择的数据
  _setSelectData(int listIndex, int positionIndex) {
    if (listIndex == 0) {
      selectProvinceStr = addressList[listIndex][positionIndex]['name'];
      selectMap['selectProvinceId'] = addressList[listIndex][positionIndex]['id'];
      setState(() {
        selectCityStr = '城市';
        selectDistrictStr = '区/县';
      });
    }

    if (listIndex == 1) {
      selectCityStr = addressList[listIndex][positionIndex]['name'];
      selectMap['selectCityId'] = addressList[listIndex][positionIndex]['id'];
      setState(() {
        selectDistrictStr = '区/县';
      });
    }
    if (listIndex == 2) {
      selectDistrictStr = addressList[listIndex][positionIndex]['name'];
      selectMap['selectDistrictId'] = addressList[listIndex][positionIndex]['id'];

      // 拼接区域字符串 回调给上个页面 关闭弹窗
      String localStr = selectProvinceStr + ' ' + selectCityStr + ' ' + selectDistrictStr;
      widget.valueCb(selectMap, localStr);
      Navigator.pop(context);
    }
  }

  // 检查是否可以选择下级Tab
  bool _checkTabCanSelect(int position) {
    print(position);
    print('position-->');
    print(selectMap);
    switch (position) {
      case 1:
        if (selectMap['selectProvinceId'] < 0) {
          _showSnack();
          return false;
        }
        break;
      case 2:
        if (selectMap['selectCityId'] < 0) {
          _showSnack();
          return false;
        }
        break;
      case 3:
        if (selectMap['selectDistrictId'] < 0) {
          _showSnack();
          return false;
        }
        break;
      default:
    }
    return true;
  }

  // 显示错误信息
  _showSnack() {
    Fluttertoast.showToast(msg: '请先选择上级地区', gravity: ToastGravity.CENTER);
  }

  // 查询区域信息
  _queryLocal(int parentId, int listIndex) async {
    // setState(() {
    //   this.localList = [];
    // });
    Map<String, dynamic> params = new Map();
    params['parentId'] = parentId;
    widget.getOneAdress(parentId, listIndex, (list) {
      this.isLoading = false;
      print('listIndex-->$listIndex');
      if (mounted) {
        if (this.addressList == null) {
          this.addressList = [[], [], []];
        }
        setState(() {
          this.addressList[listIndex] = list;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
