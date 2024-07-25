// ignore_for_file: prefer_final_fields, use_super_parameters, library_private_types_in_public_api, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:worker_application/common/constants/app_button_styles.dart';
import 'package:worker_application/common/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worker_application/common/constants/app_text_styles.dart';
import 'dart:io';

import 'package:worker_application/common/constants/textform_field.dart';
import 'package:worker_application/common/widgets/color_availability_widget.dart';
import 'package:worker_application/common/widgets/work_completion_widget.dart';

class AddWorkScreen extends StatefulWidget {
  const AddWorkScreen({Key? key}) : super(key: key);

  @override
  _AddWorkScreenState createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _colorsController = TextEditingController();
  final TextEditingController _completionTimeController = TextEditingController();
  
  List<XFile> _imageFiles = [];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Details of the work:',style: AppTextStyles.subheading(context),),
              ),
              SizedBox(height: 15,),
              CustomTextFormField(
                labelText: 'Title',
                prefixIcon: Icons.title,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Price',
                controller: _priceController,
                prefixIcon: Icons.price_check,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Description',
                controller: _descriptionController,
                prefixIcon: Icons.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Overview',
                controller: _overviewController,
                prefixIcon: Icons.details,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an overview';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Dimensions',
                controller: _dimensionsController,
                prefixIcon: Icons.height,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dimensions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
            ColorSelectionWidget(
  onColorsSelected: (colors) {
    setState(() {
      _colorsController.text = colors.join(', ');
    });
  },
),
SizedBox(height: 10,),
CustomTextFormField(
  labelText: 'Selected Colors',
  controller: _colorsController,
  readOnly: true,
),
              SizedBox(height: 16),
              WorkCompletionWidget(
  onTimeSelected: (time) {
    setState(() {
      _completionTimeController.text = time;
    });
  },
),
SizedBox(height: 10,),
CustomTextFormField(
  labelText: 'Estimated Work Completion Time',
  controller: _completionTimeController,
  readOnly: true,
),
              SizedBox(height: 24),Text('Work Images',style: AppTextStyles.body(context),),
              SizedBox(height: 8),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFiles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _imageFiles.length) {
                      return GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          color: Colors.grey[300],
                          child: Icon(Icons.add),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Image.file(File(_imageFiles[index].path), width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              color: AppColors.textPrimaryColor,
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  style: AppButtonStyles.largeButton(context),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      _submitWork();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Future<void> _submitWork() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception('No authenticated user found');
        }

        // Get worker's name from worker_profiles collection
        final workerDoc = await FirebaseFirestore.instance
            .collection('worker_profiles')
            .doc(currentUser.uid)
            .get();
        
        if (!workerDoc.exists) {
          throw Exception('Worker profile not found');
        }

        final workerName = workerDoc.data()?['name'] as String?;

        // Upload images to Firebase Storage
        List<String> imageUrls = [];
        for (var imageFile in _imageFiles) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('work_images/${DateTime.now().toIso8601String()}_${imageFile.name}');
          await ref.putFile(File(imageFile.path));
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }

        // Create a map of work data
        Map<String, dynamic> workData = {
          'workerId': currentUser.uid,
          'workerName': workerName,
          'title': _titleController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'overview': _overviewController.text,
          'dimensions': _dimensionsController.text,
          'colors': _colorsController.text.split(', '),
          'completionTime': _completionTimeController.text,
          'imageUrls': imageUrls,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save work data to Firestore
        await FirebaseFirestore.instance
            .collection('workers_works')
            .add(workData);

        // Close loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Work submitted successfully!')),
        );

        // Optionally, navigate back or clear the form
        Navigator.of(context).pop();

      } catch (e) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting work: $e')),
        );
        print('Error saving work data: $e');
      }
    }
  }
   Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _imageFiles.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

}