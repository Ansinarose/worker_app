// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io';

// import 'package:worker_application/common/constants/app_text_styles.dart';

// class PhotoWidget extends StatefulWidget {
//   @override
//   _PhotoWidgetState createState() => _PhotoWidgetState();
// }

// class _PhotoWidgetState extends State<PhotoWidget> {
//   File? _imageFile;

//   Future<void> _showImageSourceActionSheet(BuildContext context) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.camera_alt,color: Color.fromARGB(255, 27, 12, 75),),
//                 title: Text('Camera',style: AppTextStyles.body(context),),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_album,color: Color.fromARGB(255, 27, 12, 75),),
//                 title: Text('Gallery',style: AppTextStyles.body(context),),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final status = await Permission.camera.request();
//     if (status == PermissionStatus.granted) {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       }
//     } else {
//       // Handle permission denial
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Camera permission is required to take photos')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: <Widget>[
//           Text('Add Photo', style: AppTextStyles.body(context),),
//           GestureDetector(
//             onTap: () => _showImageSourceActionSheet(context),
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color.fromARGB(255, 27, 12, 75)),
//               ),
//               child: _imageFile != null
//                   ? Image.file(_imageFile!, fit: BoxFit.cover)
//                   : Icon(Icons.add_a_photo, size: 50, color:Color.fromARGB(255, 27, 12, 75) ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final VoidCallback onImageSelected;
  final String? imageUrl;

  const PhotoWidget({Key? key, required this.onImageSelected, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageSelected,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: imageUrl != null
              ? DecorationImage(
                  image: imageUrl!.startsWith('http')
                      ? NetworkImage(imageUrl!)
                      : FileImage(File(imageUrl!)) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 50,
                ),
              )
            : null,
      ),
    );
  }
}
