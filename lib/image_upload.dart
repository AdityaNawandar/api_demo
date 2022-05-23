import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

//https://fakestoreapi.com/products
class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? image;
  final imagePicker = ImagePicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => getImage(),
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: (image == null)
                      ? Image.asset(
                          'assets/choose_your_image_placeholder.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                primary: Colors.white,
              ),
              onPressed: () => uploadImage(),
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    setState(() {
      isLoading = true;
    });
    var pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      //imageQuality: 80,
    );
    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {
        isLoading = false;
      });
    }
  }

  uploadImage() async {
    if (image == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    var stream = http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = http.MultipartRequest('POST', uri);
    request.fields['title'] = 'Static Title';
    var multipartFile = http.MultipartFile('image', stream, length);
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded');
    } else {
      print('Image upload failed');
    }
    setState(() {
      isLoading = false;
    });
  }
}//class end
