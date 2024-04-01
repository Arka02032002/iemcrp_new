
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:iemcrp_new/models/embeddings.dart';
import 'package:iemcrp_new/services/datasbase.dart';
import 'package:iemcrp_new/services/face_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';


class RegisterFace extends StatefulWidget {
  const RegisterFace({Key? key}) : super(key: key);

  @override
  State<RegisterFace> createState() => _RegisterFaceState();
}

class _RegisterFaceState extends State<RegisterFace> {
  File? _image;
  late ImagePicker _picker;
  late FaceDetector faceDetector;
  // static const baseUrl = "http://192.168.0.105:5000";
  late img.Image croppedFace;
  String id=Get.arguments[0];
  String course=Get.arguments[1];
  String stream=Get.arguments[2];
  int year=Get.arguments[3];
  late int flag;
  bool isLoading=false;
  late DatabaseService db;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  void initState() {
    super.initState();

    _picker = ImagePicker();
    db= DatabaseService(uid: id);
    flag=0;

    final options =
        FaceDetectorOptions();
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
    _image = await removeRotation(_image!);

    InputImage inputImage = InputImage.fromFile(_image!);


    image = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector.processImage(inputImage);
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print(".............Rect = " + boundingBox.toString());

      num left = boundingBox.left<0?0:boundingBox.left;
      num top = boundingBox.top<0?0:boundingBox.top;
      num right = boundingBox.right>image.width?image.width-1:boundingBox.right;
      num bottom = boundingBox.bottom>image.height?image.height-1:boundingBox.bottom;
      num width = right - left;
      num height = bottom - top;

      final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes!);
      croppedFace = img.copyCrop(faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());


      showFaceRegistrationDialogue(croppedFace);
      // if(flag==1) {
      //   break;
      // }
    }
    setState(() {
      isLoading=false;
    });
    // flag=0;
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[700],
      elevation: 10,
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
    ));
  }
  Recognizer recognizer= new Recognizer();
  showFaceRegistrationDialogue(img.Image cropedFace){
    final dialogFace=Uint8List.fromList(img.encodeBmp(cropedFace));
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration",textAlign: TextAlign.center),alignment: Alignment.center,
        content: SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image.memory(
                dialogFace,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: Text("Want to register this face?",textAlign: TextAlign.center)
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(onPressed: () async{
                    Recognition record= await recognizer.register(cropedFace);
                    print(record.uid);
                    print(record.embeddings);
                    print(record.distance);
                    await db.registgerFaceEmbedding(record, course, stream, year);
                    _showSnackBar("Face registered");
                    Navigator.pop(context);

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
                    setState(() {

                    });
                  }, icon: Icon(Icons.check,color: Colors.green[700],size: 50,fill: 1,)),
                  SizedBox(
                    width: 70,
                  ),

                  IconButton(onPressed: (){
                    // doFaceDetection();
                    Navigator.pop(context);
                  }, icon: Icon(Icons.close,color: Colors.red[700],size: 50,fill: 1,))
                ],
              ),
            ],
          ),
        ),contentPadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Registration"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          _image != null
              ? isLoading? SizedBox(
              width: screenWidth,
              height: screenHeight / 2.25,child: Center(child: CircularProgressIndicator(),)):Image.file(
                  _image!,
                  width: screenWidth,
                  height: screenHeight / 2,
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

          if(_image!=null)
            ElevatedButton(onPressed: () {
              doFaceDetection();


              // showFaceRegistrationDialogue(_image);
            }, child: Text("Register"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700],minimumSize: const Size(200,40)),)
          else
          SizedBox(
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
    );
  }
}
