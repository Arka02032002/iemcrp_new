class Assignment{
  String ?desc="";
  String subject="";
  String stream="";
  String teacher="";
  String ?fileUrl="";
  int year=0;

  Assignment({this.desc,required this.subject,required this.teacher,required this.stream,this.fileUrl,required this.year});
}