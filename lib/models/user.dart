class IemcrpUser{
  final String uid;
  final String? email;
  DateTime? creationdt;
  DateTime? lastsignindt;
  IemcrpUser({required this.uid,required this.email,required this.creationdt,required this.lastsignindt});
}