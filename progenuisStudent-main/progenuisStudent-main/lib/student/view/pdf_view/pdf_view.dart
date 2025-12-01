
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:no_screenshot/no_screenshot.dart';
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

  final NoScreenshot _noScreenshot = NoScreenshot();

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF(widget.pdfUrl);
    _noScreenshot.screenshotOff();
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



