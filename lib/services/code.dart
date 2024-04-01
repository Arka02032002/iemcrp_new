
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


class Attendence_Code{
  String code="";
  String stream="";
  int period=0;
  int year=0;
  Attendence_Code({required this.stream,required this.period,required this.year});

  var uuid=Uuid();
  DatabaseService db= new DatabaseService();
  Future generateCode() async{
    code= uuid.v1();
    db.updateCodeData(code, stream,period,year);
    db.createAttendenceData(stream,period,DateFormat("yyyy-MM-dd").format(DateTime.now()),year);
    // globals.code=code;
    // globals.stream=stream;
    return code;
  }
}