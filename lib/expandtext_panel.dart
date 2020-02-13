import 'package:flutter/material.dart';

class ExpandTextPanel extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  final bool isExpand;
  final expandItem;
  final putawayItem;
  const ExpandTextPanel({
    Key key,
    this.text,
    this.maxLines,
    this.style,
    this.isExpand,
    this.expandItem,
    this.putawayItem,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ExpandTextPanelState(text, maxLines, style, isExpand);
}

class _ExpandTextPanelState extends State<ExpandTextPanel> {
  final String text;
  final int maxLines;
  final TextStyle style;
  bool isExpand;
  _ExpandTextPanelState(this.text, this.maxLines, this.style, this.isExpand) {
    if (isExpand == null) {
      isExpand = false;
    }
  }

  Widget tipText() {
    return isExpand ? putawayItem() : expandItem();
  }

  Widget expandItem() {
    if (widget.expandItem is Widget) {
      return widget.expandItem;
    }
    return Text(
      widget.expandItem ?? '全文',
      style: TextStyle(
        fontSize: style != null ? style.fontSize : null,
        color: Colors.blue,
      ),
    );
  }

  Widget putawayItem() {
    if (widget.putawayItem is Widget) {
      return widget.putawayItem;
    }
    return Text(
      widget.putawayItem ?? '收起',
      style: TextStyle(
        fontSize: style != null ? style.fontSize : null,
        color: Colors.blue,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text ?? '', style: style);
      final tp = TextPainter(text: span, maxLines: maxLines, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);
      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isExpand
                ? Text(text ?? '', style: style)
                : Text(text ?? '', maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  isExpand = !isExpand;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 2),
                child: tipText(),
              ),
            ),
          ],
        );
      } else {
        return Text(text ?? '', style: style);
      }
    });
  }
}
