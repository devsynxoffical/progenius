class LessonModel {
  String? id;
  String? title;
  String? chapter;
  List<dynamic>? videos;
  List<dynamic>? quizes;
  List<PdfModel>? pdfs; // PdfModel type should be used here correctly

  LessonModel({
    this.id,
    this.title,
    this.chapter,
    this.videos,
    this.quizes,
    this.pdfs,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['_id'],
      title: json['title'],
      chapter: json['chapter'],
      videos: json['videos'],
      quizes: json['quizes'],
      // Ensure that pdfs is properly mapped to PdfModel
      pdfs: (json['pdfs'] as List<dynamic>?)
          ?.map((pdf) => PdfModel.fromJson(pdf)) // Mapping the pdf JSON to PdfModel
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'chapter': chapter,
      'videos': videos,
      'quizes': quizes,
      // Ensure that pdfs is serialized to JSON correctly
      'pdfs': pdfs?.map((pdf) => pdf.toJson()).toList(),
    };
  }
}

class PdfModel {
  String? title;
  String? file;
  String? destination;
  String? id;

  PdfModel({
    this.title,
    this.file,
    this.destination,
    this.id,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      title: json['title'],
      file: json['file'],
      destination: json['destination'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'file': file,
      'destination': destination,
    };
  }
}
