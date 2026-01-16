import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class DocumentUploadScreen extends StatefulWidget {

  const DocumentUploadScreen({super.key,});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  
  // Document types with field names matching API
  final List<DocumentItem> documents = [
    DocumentItem(
      title: 'Passport Size Photo',
      apiField: 'image1',
      icon: Icons.camera_alt,
      file: null,
      base64Data: '',
    ),
    DocumentItem(
      title: 'Photo ID',
      apiField: 'image2',
      icon: Icons.badge,
      file: null,
      base64Data: '',
    ),
    DocumentItem(
      title: 'Residential Proof',
      apiField: 'image3',
      icon: Icons.home,
      file: null,
      base64Data: '',
    ),
    DocumentItem(
      title: 'Education Qualification',
      apiField: 'image4',
      icon: Icons.school,
      file: null,
      base64Data: '',
    ),
  ];

  // API Configuration
  final String _apiUrl = 'https://jinreflexology.in/api1/new/upload_documents.php';

  // Upload function with API call
  Future<void> _uploadDocument(int index) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          _buildSourceOption(
            context,
            Icons.camera_alt,
            'Take Photo',
            'camera',
          ),
          _buildSourceOption(
            context,
            Icons.photo_library,
            'Choose from Gallery',
            'gallery',
          ),
          _buildSourceOption(
            context,
            Icons.insert_drive_file,
            'Choose File',
            'file',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    if (action == null) return;

    if (action == 'camera') {
      await _takePhoto(index);
    } else if (action == 'gallery') {
      await _pickImageFromGallery(index);
    } else if (action == 'file') {
      await _pickFile(index);
    }
  }

  Widget _buildSourceOption(
      BuildContext context, IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () => Navigator.pop(context, value),
    );
  }

  // Take photo using camera
  Future<void> _takePhoto(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        await _processSelectedFile(index, File(pickedFile.path));
      }
    } catch (e) {
      _showError('Camera Error: $e');
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        await _processSelectedFile(index, File(pickedFile.path));
      }
    } catch (e) {
      _showError('Gallery Error: $e');
    }
  }

  // Pick file
  Future<void> _pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        await _processSelectedFile(index, file);
      }
    } catch (e) {
      _showError('File Error: $e');
    }
  }

  // Process selected file and convert to base64
  Future<void> _processSelectedFile(int index, File file) async {
    try {
      // Read file as bytes
      List<int> fileBytes = await file.readAsBytes();
      
      // Get file extension
      String extension = file.path.split('.').last.toLowerCase();
      String mimeType;
      
      // Determine MIME type
      if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'doc' || extension == 'docx') {
        mimeType = 'application/msword';
      } else {
        mimeType = 'application/octet-stream';
      }
      
      // Convert to base64
      String base64Data = base64Encode(fileBytes);
      String formattedBase64 = 'data:$mimeType;base64,$base64Data';
      
      // Get file size in KB
      double fileSizeKB = fileBytes.length / 1024;
      
      if (fileSizeKB > 1024) { // 1MB limit
        _showError('File size should be less than 1MB');
        return;
      }
      
      setState(() {
        documents[index] = documents[index].copyWith(
          file: file,
          base64Data: formattedBase64,
          fileName: file.path.split('/').last,
          fileSize: '${fileSizeKB.toStringAsFixed(1)} KB',
        );
      });
      
      _showSuccess('${documents[index].title} uploaded successfully');
    } catch (e) {
      _showError('Error processing file: $e');
    }
  }

  // Submit all documents to API
  Future<void> _submitDocuments() async {
    // Validate all documents are uploaded
    for (var doc in documents) {
      if (doc.base64Data.isEmpty) {
        _showMissingDocumentsDialog();
        return;
      }
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      // Prepare request body
      Map<String, String> requestBody = {
        'id': AppPreference().getString(PreferencesKey.userId).toString(),
      };



      // Add base64 data for each document
      for (var doc in documents) {
        requestBody[doc.apiField] = doc.base64Data;
      }

      // Make API call
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      // Update progress
      setState(() => _uploadProgress = 1.0);

      // Parse response
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['status'] == true) {
          _showSuccessDialog('Documents uploaded successfully!');
          Navigator.pop(context);
        } else {
          _showError('Upload failed: ${responseData['message']}');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showMissingDocumentsDialog() {
    List<String> missingDocs = [];
    for (var doc in documents) {
      if (doc.base64Data.isEmpty) {
        missingDocs.add(doc.title);
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please upload all required documents:'),
            const SizedBox(height: 15),
            ...missingDocs.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text('• $doc'),
            )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Document Upload"),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upload Required Documents',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'User ID: ${AppPreference().getString(PreferencesKey.userId).toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Please upload all 4 documents below. Supported formats: JPG, PNG, PDF, DOC',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Document Cards Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return _buildDocumentCard(index);
                  },
                ),

                const SizedBox(height: 30),

                // Progress Indicator
                if (_isUploading)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _submitDocuments,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _isUploading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'UPLOADING...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'SUBMIT ALL DOCUMENTS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Notes:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('• Each file should be less than 1MB'),
                      Text('• Supported formats: JPG, PNG, PDF, DOC'),
                      Text('• Clear and readable documents required'),
                      Text('• All 4 documents are mandatory'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(int index) {
    final doc = documents[index];
    final hasFile = doc.base64Data.isNotEmpty;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _uploadDocument(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with status
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: hasFile ? Colors.green[100] : Colors.blue[100],
                    child: Icon(
                      doc.icon,
                      size: 30,
                      color: hasFile ? Colors.green : Colors.blue,
                    ),
                  ),
                  if (hasFile)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 15),

              // Title
              Text(
                doc.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 10),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: hasFile ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasFile ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  hasFile ? 'UPLOADED' : 'PENDING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasFile ? Colors.green : Colors.orange,
                  ),
                ),
              ),

              // File info if uploaded
              if (hasFile && doc.fileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Text(
                        doc.fileName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (doc.fileSize != null)
                        Text(
                          doc.fileSize!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Document Model
class DocumentItem {
  final String title;
  final String apiField;
  final IconData icon;
  final File? file;
  final String base64Data;
  final String? fileName;
  final String? fileSize;

  DocumentItem({
    required this.title,
    required this.apiField,
    required this.icon,
    this.file,
    required this.base64Data,
    this.fileName,
    this.fileSize,
  });

  DocumentItem copyWith({
    String? title,
    String? apiField,
    IconData? icon,
    File? file,
    String? base64Data,
    String? fileName,
    String? fileSize,
  }) {
    return DocumentItem(
      title: title ?? this.title,
      apiField: apiField ?? this.apiField,
      icon: icon ?? this.icon,
      file: file ?? this.file,
      base64Data: base64Data ?? this.base64Data,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}