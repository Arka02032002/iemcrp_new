import 'package:flutter/material.dart';

class Bill{
  int id=0;
  int sem=0;
  int amt=0;
  String ?billdt;
  String url='';

  Bill({required this.id,required this.sem,required this.amt,required this.billdt,required this.url});
}