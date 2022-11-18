import 'package:iemcrp_new/services/datasbase.dart';
import 'package:uuid/uuid.dart';
import 'package:iemcrp_new/globals.dart' as globals;

class Attendence_Code{
  String code="";
  String stream="";
  int period=0;
  Attendence_Code({required this.stream,required this.period});

  var uuid=Uuid();
  DatabaseService db= new DatabaseService();
  Future generateCode() async{
    code= uuid.v1();
    db.updateCodeData(code, stream,period);
    // globals.code=code;
    // globals.stream=stream;
    return code;
  }
}