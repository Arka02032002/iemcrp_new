
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:iemcrp_new/models/embeddings.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:iemcrp_new/services/face_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


import '../../models/students.dart';
import '../../shared/constants.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  File? _image;
  late ImagePicker _picker;
  late FaceDetector faceDetector;
  // static const baseUrl = "http://192.168.0.105:5000";
  late img.Image croppedFace;
  // String id=Get.arguments[0];
  String course = "";
  String stream = "";
  int year = 0;
  int period = 0;
  late int flag;
  bool isLoading = false;
  // late DatabaseService db;

  @override
  void initState() {
    super.initState();

    _picker = ImagePicker();
    // db= DatabaseService(uid: id);
    flag = 0;

    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);
  }

  chooseImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        // doFaceDetection();
      });
    }
  }

  captureImage() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        // doFaceDetection();
      });
    }
  }

  List<Face> faces = [];
  var image;
  Future doFaceDetection() async {
    setState(() {
      isLoading=true;
    });

      // showDialog(
      //   context: context,
      //   // barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // );

    // await Future.delayed(Duration(milliseconds: 50));

    _image = await removeRotation(_image!);

    InputImage inputImage = InputImage.fromFile(_image!);

    image = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector.processImage(inputImage);
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print(".............Rect = " + boundingBox.toString());

      num left = boundingBox.left <= 0 ? 0 : boundingBox.left;
      num top = boundingBox.top <= 0 ? 0 : boundingBox.top;
      num bottom = boundingBox.bottom >= image.height
          ? image.height - 1
          : boundingBox.bottom;
      num right = boundingBox.right >= image.width
          ? image.width - 1
          : boundingBox.right;
      num width = right - left;
      num height = bottom - top;

      final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes!);
      croppedFace = img.copyCrop(faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());
      // await Future.delayed(Duration(milliseconds: 50));


      showFaceRegistrationDialogue(croppedFace);
      // if(flag==1) {
      //   break;
      // }
    }
      // Navigator.of(context).pop();
    setState(() {
      isLoading=false;
    });

    // flag=0;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[700],
      elevation: 10,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
    ));
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  Recognizer recognizer = new Recognizer();
  showFaceRegistrationDialogue(img.Image cropedFace) {
    final dialogFace = Uint8List.fromList(img.encodeBmp(cropedFace));
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Recognition", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                dialogFace,
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 200,
                  child: Text("Present ?", textAlign: TextAlign.center)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(
                      onPressed: () async {
                        Recognition record = await recognizer.recognize(
                            cropedFace, course, stream, year);
                        print(record.uid);
                        DatabaseService(uid: record.uid).updateAttendenceData(
                            period,
                            DateFormat("yyyy-MM-dd").format(DateTime.now()));
                        Student student =
                            await DatabaseService().getStudentById(record.uid);
                        String name = student.name;
                        _showSnackBar("$name marked present");
                        print(record.embeddings);
                        print(record.distance);
                        Navigator.pop(context);
                        // await db.registgerFaceEmbedding(record, course, stream, year);

                        // final request= http.MultipartRequest("POST",Uri.parse("$baseUrl/upload"));
                        // final headers={
                        //   "Content-type": "multipart/form-data"
                        // };
                        // final fields={
                        //   "id": id,
                        //   "course": course,
                        //   "stream": stream,
                        //   "year": year.toString()
                        // };
                        // request.fields.addAll(fields);
                        // List<int> jpgBytes = img.encodeJpg(croppedFace);
                        // Directory tempDir = await getTemporaryDirectory();
                        // String tempPath = tempDir.path;
                        // File file = File('$tempPath/temp_image.jpg');
                        // await file.writeAsBytes(jpgBytes);

                        // request.files.add(http.MultipartFile('image',_image!.readAsBytes().asStream(),_image!.lengthSync(),filename: "img2.jpg"));
                        // // request.files.add();
                        // request.headers.addAll(headers);
                        // final response= await request.send();
                        // http.Response res= await http.Response.fromStream(response);
                        // final resJson= await jsonDecode(res.body);
                        // final message= resJson['message'];
                        // print(message);
                        // // flag=1;
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.green[700],
                        size: 50,
                        fill: 1,
                      )),
                  SizedBox(
                    width: 70,
                  ),
                  IconButton(
                      onPressed: () {
                        // doFaceDetection();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red[700],
                        size: 50,
                        fill: 1,
                      ))
                ],
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Face Recognition"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: screenWidth / 2 - 5,
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter Course'),
                    onChanged: (val) {
                      setState(() {
                        course = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: screenWidth / 2 - 5,
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter Stream'),
                    onChanged: (val) {
                      setState(() {
                        stream = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                SizedBox(
                  width: screenWidth / 2 - 5,
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter Year'),
                    onChanged: (val) {
                      setState(() {
                        year = int.parse(val);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: screenWidth / 2 - 5,
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter Period'),
                    onChanged: (val) {
                      setState(() {
                        period = int.parse(val);
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            _image != null
                ?isLoading?SizedBox(
                width: screenWidth,
                height: screenHeight / 2.25,child: Center(child: SpinKitCircle(color: Colors.green, size: 50,),)): Image.file(
                    _image!,
                    width: screenWidth,
                    height: screenHeight / 2.25,
                  )
                : Opacity(
                    opacity: 0.3,
                    child: SizedBox(
                      width: screenWidth,
                      height: screenHeight / 2.25,
                      child: Icon(
                        Icons.image,
                        size: 350,
                      ),
                    )),
            SizedBox(
              height: 20,
            ),

            _image != null
                ? ElevatedButton(
                    onPressed: () {
                      if (course == "" ||
                          stream == "" ||
                          year == 0 ||
                          period == 0)
                        _showSnackBar("Enter all parameters");
                      else {

                        doFaceDetection();

                      }

                      // showFaceRegistrationDialogue(_image);
                    },
                    child: Text("Mark Attendance"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(200, 40)),
                  )
                : SizedBox(
                    height: 40,
                  ),
            SizedBox(
              height: 30,
            ),
            //Container for buttons
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(200))),
                    child: InkWell(
                      onTap: () {
                        chooseImage();
                      },
                      child: SizedBox(
                        width: screenWidth / 3 - 50,
                        height: screenWidth / 3 - 50,
                        child: Icon(Icons.image,
                            color: Colors.green[700], size: screenWidth / 7),
                      ),
                    ),
                  ),
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(200))),
                    child: InkWell(
                      onTap: () {
                        captureImage();
                      },
                      child: SizedBox(
                        width: screenWidth / 3 - 50,
                        height: screenWidth / 3 - 50,
                        child: Icon(Icons.camera,
                            color: Colors.green[700], size: screenWidth / 7),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
