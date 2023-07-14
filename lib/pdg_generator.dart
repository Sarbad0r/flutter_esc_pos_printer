import 'dart:io';

import 'package:flutter/cupertino.dart' as matW;
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as ren;

class PdfGenerator {
  static late Font font;
  static late Font boldFont;

  static init() async {
    font = Font.ttf((await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")));
    boldFont = Font.ttf((await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")));
  }

  static Future<String?> createPdf() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    File file = File("${path}MY2_PDF.pdf");

    Document pdf = Document();
    pdf.addPage(_createPage());

    Uint8List bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    return convertToImage(file.path);
  }

  static Page _createPage() {
    return Page(
        textDirection: TextDirection.rtl,
        pageFormat: PdfPageFormat.roll57,
        theme: ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Text("Avera", style: TextStyle(fontSize: 12))),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("Дата: ${DateTime.now().toString().substring(0, 19)}",
                    style: TextStyle(fontSize: 8))
              ]),
              SizedBox(height: 15),
              Row(children: [
                Expanded(
                    child: Text("N", textAlign: TextAlign.left, style: TextStyle(fontSize: 8))),
                Expanded(
                    child:
                        Text("Наим-ие", textAlign: TextAlign.left, style: TextStyle(fontSize: 8))),
                Expanded(
                    child:
                        Text("Кол-во", textAlign: TextAlign.center, style: TextStyle(fontSize: 8))),
                Expanded(
                    child:
                        Text("Цена", textAlign: TextAlign.center, style: TextStyle(fontSize: 8))),
                Expanded(
                    child:
                        Text("Сумма", textAlign: TextAlign.center, style: TextStyle(fontSize: 8))),
              ])
            ]));
  }

  static Future<String?> convertToImage(String pdfPath) async {
    ren.PdfDocument doc = await ren.PdfDocument.openFile(pdfPath);
    ren.PdfPage page = await doc.getPage(1);

    final ren.PdfPageImage? pageImg =
        await page.render(width: 575, height: page.height + 200, backgroundColor: "#ffffff");

    if (pageImg != null) {
      String path = (await getApplicationDocumentsDirectory()).path;
      File file = File("${path}MY2_IMG.png");

      await file.writeAsBytes(pageImg.bytes);
      // OpenFile.open(file.path);
      return file.path;
    }
    return null;
  }
}
