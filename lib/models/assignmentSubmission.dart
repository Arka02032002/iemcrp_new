class AssignmentSubmission{
  String ?desc="";
  String name="";
  String ?fileUrl="";
  String stream="";
  String enrollment="";
  String subject="";
  String id="";
  int? year=0;

  AssignmentSubmission({required this.id,this.desc,required this.name,this.fileUrl,required this.stream,required this.enrollment,required this.subject,this.year});
}