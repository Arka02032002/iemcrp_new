import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/embeddings.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  // final dbHelper = DatabaseHelper();
  Map<String,List<double>> registered = Map();
  late CollectionReference stored_embeddings;
  @override
  String get modelName => 'assets/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();
    stored_embeddings = FirebaseFirestore.instance.collection('embeddings');

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    // initDB();
  }

  // initDB() async {
  //   // await dbHelper.init();
  //   // loadRegisteredFaces();
  // }

  Future<void> loadRegisteredFaces(String course,String stream,int year) async {
    // stored_embeddings.doc(course).collection(stream).doc(year.toString()).snapshots().forEach((element) {
    //   print(element.data());
    // });
    // print();
    DocumentSnapshot snapshot = await stored_embeddings.doc(course).collection(stream).doc(year.toString()).get();
    if(snapshot.exists){
      Map<String, dynamic> dynamicMap = snapshot.data() as Map<String, dynamic>;
      registered = dynamicMap.map((key, value) {
        return MapEntry(key, (value as List<dynamic>).cast<double>());
      });
      // registered= snapshot.data() as Map<String,List<dynamic>>;
    }
    print("Database Data: ");


  }

  // void registerFaceInDB(String name, List<double> embedding) async {
  //   // row to insert
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.columnName: name,
  //     DatabaseHelper.columnEmbedding: embedding.join(",")
  //   };
  //   final id = await dbHelper.insert(row);
  //   print('inserted row id: $id');
  // }


  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage){
    img.Image resizedImage = img.copyResize(inputImage!, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!.expand((channel) => [channel.r, channel.g, channel.b]).map((value) => value.toDouble()).toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] = (float32Array[c * height * width + h * width + w]-127.5)/127.5;
        }
      }
    }
    return reshapedArray.reshape([1,112,112,3]);
  }

  Future<Recognition> register(img.Image image) async {

    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    List output = List.filled(1*192, 0).reshape([1,192]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
    List<double> outputArray = await output.first.cast<double>();

    //TODO looks for the nearest embeeding in the database and returns the pair
    Pair pair = await findNearest(outputArray);
    print("distance= ${pair.distance}");

    return Recognition(pair.id,outputArray,pair.distance);
  }

  Future<Recognition> recognize(img.Image image,String course,String stream,int year) async {

    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    List output = List.filled(1*192, 0).reshape([1,192]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();
    print(outputArray);

    await loadRegisteredFaces(course,stream,year);



    //TODO looks for the nearest embeeding in the database and returns the pair
    Pair pair = findNearest(outputArray);
    print("distance= ${pair.distance}");

    return Recognition(pair.id,outputArray,pair.distance);
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb) {
    print("Entered");
    Pair pair = Pair("Unknown", -5);
    for (MapEntry<String, List<double>> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value;
      print(name);
      print(knownEmb);
      print(knownEmb.length);
      print(emb.length);
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] -
            knownEmb[i];
        distance += diff*diff;
      }
      distance = sqrt(distance);
      print(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.id = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }

}
class Pair{
  String id;
  double distance;
  Pair(this.id,this.distance);
}


