import '../allExport.dart';


class PorfileName extends StatefulWidget {
  PorfileName({Key key,@required this.title,@required this.size,@required this.color}):super(key:key);
  String title;
  double size;
  Color color;
  @override
  _PorfileNameState createState() => _PorfileNameState();
}

class _PorfileNameState extends State<PorfileName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.title,style: TextStyle(fontSize: widget.size,color: Colors.white ,fontFamily: 'DancingScript' ,fontWeight: FontWeight.w700)),
    );
  }
}