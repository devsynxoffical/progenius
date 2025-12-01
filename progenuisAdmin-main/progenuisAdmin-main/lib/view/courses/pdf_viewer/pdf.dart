import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  PdfViewerPage({required this.pdfUrl});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localFilePath;
  bool _isLoading = true;
  String? _errorMessage;
  File? _pdfFile;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isPdfReady = false;
  double _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF(widget.pdfUrl);
  }

  Future<void> _downloadAndSavePDF(String url) async {
    try {
      final uri = Uri.parse(url);
      final request = http.Request('GET', uri);
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final contentLength = response.contentLength ?? 0;
        List<int> bytes = [];
        int received = 0;

        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/lesson.pdf');
        final sink = file.openWrite();

        response.stream.listen(
          (chunk) {
            bytes.addAll(chunk);
            received += chunk.length;
            setState(() {
              _downloadProgress = (received / contentLength);
            });
            sink.add(chunk);
          },
          onDone: () async {
            await sink.close();
            setState(() {
              localFilePath = file.path;
              _pdfFile = file;
              _isLoading = false;
            });
          },
          onError: (error) {
            setState(() {
              _errorMessage = "Failed to download PDF: $error";
              _isLoading = false;
            });
          },
          cancelOnError: true,
        );
      } else {
        throw Exception("Failed to download PDF: Status code ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print("Error downloading PDF: $e");
    }
  }

  @override
  void dispose() {
    if (_pdfFile != null && _pdfFile!.existsSync()) {
      _pdfFile!.deleteSync();
      print("PDF file deleted from local storage.");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: _downloadProgress),
                  SizedBox(height: 16),
                  Text(
                    'Downloading PDF... ${(_downloadProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        "Error: $_errorMessage",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          _downloadAndSavePDF(widget.pdfUrl);
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    PDFView(
                      filePath: localFilePath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: false,
                      onRender: (pages) {
                        setState(() {
                          _totalPages = pages!;
                          _isPdfReady = true;
                        });
                      },
                      onError: (error) {
                        print("Error loading PDF: $error");
                        setState(() {
                          _errorMessage = "Failed to load PDF.";
                        });
                      },
                      onPageError: (page, error) {
                        print("Error on page $page: $error");
                      },
                      onPageChanged: (page, total) {
                        setState(() {
                          _currentPage = page!;
                        });
                      },
                    ),
                    if (_isPdfReady)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Page ${_currentPage + 1} of $_totalPages',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class PdfViewerPage extends StatefulWidget {
//   final String pdfUrl;

//   const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

//   @override
//   _PdfViewerPageState createState() => _PdfViewerPageState();
// }

// class _PdfViewerPageState extends State<PdfViewerPage> {
//   late PdfViewerController _pdfViewerController;
//   File? _pdfFile;
//   bool _isLoading = true;
//   String? _errorMessage;
//   double _downloadProgress = 0;
//   bool _isDownloading = false;
//   bool _isPdfReady = false;

//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _isDownloading = true;
//         _errorMessage = null;
//       });

//       final uri = Uri.parse(widget.pdfUrl);
//       final request = http.Request('GET', uri);
//       final response = await http.Client().send(request);

//       if (response.statusCode == 200) {
//         final contentLength = response.contentLength ?? 0;
//         final dir = await getTemporaryDirectory();
//         final file = File('${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');
//         final sink = file.openWrite();

//         int received = 0;
//         await response.stream.listen(
//           (chunk) {
//             received += chunk.length;
//             setState(() {
//               _downloadProgress = received / contentLength;
//             });
//             sink.add(chunk);
//           },
//           onDone: () async {
//             await sink.close();
//             setState(() {
//               _pdfFile = file;
//               _isLoading = false;
//               _isDownloading = false;
//               _isPdfReady = true;
//             });
//           },
//           onError: (error) {
//             sink.close();
//             setState(() {
//               _errorMessage = "Download failed: ${error.toString()}";
//               _isLoading = false;
//               _isDownloading = false;
//             });
//           },
//           cancelOnError: true,
//         ).asFuture();
//       } else {
//         throw Exception("HTTP Error ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//         _isDownloading = false;
//       });
//     }
//   }

//   Future<void> _retryDownload() async {
//     if (_pdfFile != null && _pdfFile!.existsSync()) {
//       await _pdfFile!.delete();
//     }
//     await _loadPdf();
//   }

//   @override
//   void dispose() {
//     _pdfViewerController.dispose();
//     // Delete the temporary file when the widget is disposed
//     if (_pdfFile != null && _pdfFile!.existsSync()) {
//       _pdfFile!.delete().catchError((e) {
//         debugPrint("Error deleting PDF file: $e");
//       });
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//         actions: [
//           if (_isPdfReady)
//             IconButton(
//               icon: const Icon(Icons.zoom_in),
//               onPressed: () {
//                 _pdfViewerController.zoomLevel += 0.5;
//               },
//             ),
//           if (_isPdfReady)
//             IconButton(
//               icon: const Icon(Icons.zoom_out),
//               onPressed: () {
//                 _pdfViewerController.zoomLevel -= 0.5;
//               },
//             ),
//           if (_isPdfReady)
//             IconButton(
//               icon: const Icon(Icons.first_page),
//               onPressed: () {
//                 _pdfViewerController.firstPage();
//               },
//             ),
//           if (_isPdfReady)
//             IconButton(
//               icon: const Icon(Icons.last_page),
//               onPressed: () {
//                 _pdfViewerController.lastPage();
//               },
//             ),
//         ],
//       ),
//       body: _buildBody(),
//       floatingActionButton: _isPdfReady
//           ? FloatingActionButton(
//               child: const Icon(Icons.bookmark),
//               onPressed: () {
//                 // Get current page and show in snackbar
//                 final currentPage = _pdfViewerController.pageNumber;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Current Page: $currentPage'),
//                     duration: const Duration(seconds: 1),
//                   ),
//                 );
//               },
//             )
//           : null,
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_isDownloading)
//               Column(
//                 children: [
//                   CircularProgressIndicator(value: _downloadProgress),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Downloading PDF... ${(_downloadProgress * 100).toStringAsFixed(1)}%',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               )
//             else
//               const CircularProgressIndicator(),
//           ],
//         ),
//       );
//     }

//     if (_errorMessage != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 48),
//               const SizedBox(height: 16),
//               Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _retryDownload,
//                 child: const Text('Retry Download'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_pdfFile != null && _isPdfReady) {
//       return SfPdfViewer.file(
//         _pdfFile!,
//         controller: _pdfViewerController,
//         pageLayoutMode: PdfPageLayoutMode.single,
//         scrollDirection: PdfScrollDirection.vertical,
//         canShowScrollHead: true,
//         canShowScrollStatus: true,
//         interactionMode: PdfInteractionMode.pan,
//         onDocumentLoaded: (PdfDocumentLoadedDetails details) {
//           // Document loaded callback
//           debugPrint('Document loaded: ${details.document.pages.count} pages');
//         },
//         onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
//           // Document load failed callback
//           setState(() {
//             _errorMessage = "Failed to load PDF: ${details.error}";
//             _isPdfReady = false;
//           });
//         },
//         onPageChanged: (PdfPageChangedDetails details) {
//           // Page changed callback
//           debugPrint('Page changed: ${details.newPageNumber}');
//         },
//       );
//     }

//     return const Center(child: Text('No PDF available'));
//   }
// }