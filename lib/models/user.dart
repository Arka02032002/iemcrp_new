class IemcrpUser{
  final String uid;
  final String? email;
  // dynamic metadata;
  DateTime? creationdt;
  DateTime? lastsignindt;
  IemcrpUser({required this.uid,required this.email,required this.creationdt,required this.lastsignindt});
}