import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class ReceiptServices{


  Future<Uint8List> createBillReceipt(String name,String course,String stream,String enrollment,int sem,int year,int amt) async {
    final pdf=pw.Document();
    final image= (await rootBundle.load("assets/logo-removebg.png")).buffer.asUint8List();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
        build:(pw.Context context){
      return pw.Container(
        child: pw.Column(
          // mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(pw.MemoryImage(image),width: 200,height: 200,fit: pw.BoxFit.contain)
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text("Payment Receipt",style: pw.TextStyle(fontSize: 30)),
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
              padding:pw.EdgeInsets.symmetric(horizontal:6.0),
              child:pw.Container(
                height:2.0,
                width:double.maxFinite,
                color:PdfColors.black,),
            ),
            pw.SizedBox(height: 30),
            pw.Text("Semester: $sem",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            pw.Text("Name: $name",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            pw.Text("Course: $course",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            pw.Text("Year: $year",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            pw.Text("Stream: $stream",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            pw.Text("Enrollment: $enrollment",style: pw.TextStyle(fontSize: 30)),
            pw.SizedBox(height: 10),
            // pw.Row(children: [
            //   pw.Text("Amount: ",style: pw.TextStyle(fontSize: 30)),
            //   pw.Icon(pw.IconData(Icons.currency_rupee.codePoint)),
            // ])
            pw.Text("Amount:  INR $amt",style: pw.TextStyle(fontSize: 30)),
          ]
        )
      );
    }));
    return pdf.save();

  }

  Future<String> saveBill(String fileName, Uint8List byteList) async{
    final output= await getTemporaryDirectory();
    var filePath="${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
    final ref=FirebaseStorage.instance.ref().child('receipts/$fileName.pdf');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}