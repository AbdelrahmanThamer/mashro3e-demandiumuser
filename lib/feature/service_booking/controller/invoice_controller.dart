import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:demandium/core/helper/date_converter.dart';
import 'package:demandium/feature/profile/controller/user_controller.dart';
import 'package:demandium/feature/service_booking/controller/booking_details_tabs_controller.dart';
import 'package:demandium/feature/service_booking/model/booking_details_model.dart';
import 'package:demandium/feature/service_booking/model/invoice.dart';
import 'package:demandium/feature/splash/controller/splash_controller.dart';
import 'package:demandium/utils/dimensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceController {
   static Future<Uint8List> generateUint8List(
       BookingDetailsContent bookingDetailsContent,
       List<InvoiceItem> items,
       BookingDetailsTabsController controller) async{
     final pdf = Document();
     final netImage = await networkImage('${Get.find<SplashController>().configModel.content!.imageBaseUrl}'
         '/business/${Get.find<SplashController>().configModel.content!.logo}');

     final date = DateTime.now();
     var invoice = Invoice(provider: Provider(
       name: bookingDetailsContent.provider != null? bookingDetailsContent.provider!.companyName! :'',
       address: bookingDetailsContent.provider != null? bookingDetailsContent.provider!.companyAddress!: '',
       phone: bookingDetailsContent.provider != null? bookingDetailsContent.provider!.companyPhone!: '',
      ),
      info: InvoiceInfo(
        date: date,
        description: 'Payment Status : ',
        number: bookingDetailsContent.readableId.toString(),
        paymentStatus: bookingDetailsContent.isPaid == 0 ?"Unpaid": 'Paid',
      ),
      items: items,
    );



    pdf.addPage(MultiPage(
      build: (context) => [
        buildInvoiceImage(netImage,bookingDetailsContent,invoice),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(bookingDetailsContent,controller),
      ],
      footer: (context) => buildFooter(bookingDetailsContent),
    ));

    return pdf.save();
  }

  static Widget buildHeader(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildProviderAddress(invoice.provider),
          buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildProviderAddress(Provider provider) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(provider.name, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(provider.address),
      Text(provider.phone),
    ],
  );

  static Widget buildInvoiceInfo(InvoiceInfo info) {

    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Status:',

    ];
    final data = <String>[
      info.number,
      DateConverter.dateStringMonthYear(info.date),
      info.paymentStatus,

    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];
        return buildText(title: title, value: value, width: 200);
      }),
    );
  }






  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address),
    ],
  );

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'INVOICE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      //Text(invoice.info.description),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Unit Price',
      'Quantity',
      'Discount',
      'Tax',
      'Total',
    ];
    final data = invoice.items.map((item) {
      //final total = item.unitPrice * item.quantity * (1 + item.vat);
      return [
        item.serviceName,
        item.unitPrice,
        item.quantity,
        item.discountAmount,
        item.tax,
        item.unitAllTotal,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      columnWidths: {
        0: FixedColumnWidth(Get.width / 4),
      },
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(BookingDetailsContent bookingDetailsContent,BookingDetailsTabsController controller) {


    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total discount',
                  value: controller.totalDiscountWithCoupon.toString(),
                  unite: true,
                ),
                buildText(
                  title: 'Tax',
                  value: bookingDetailsContent.totalTaxAmount!.toStringAsFixed(2),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Grand Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: controller.bookingDetailsContent!.totalBookingAmount!.toStringAsFixed(2),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(BookingDetailsContent bookingDetailsContent) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: '', value: "${bookingDetailsContent.customer!.firstName} ${bookingDetailsContent.customer!.lastName}"),
      SizedBox(height: 1 * PdfPageFormat.mm),

      SizedBox(height: 1 * PdfPageFormat.mm),
      bookingDetailsContent.serviceAddress != null ?
      buildSimpleText(title: '', value: "${bookingDetailsContent.serviceAddress!.address!.contains('null') ? '': bookingDetailsContent.serviceAddress!.address},"
          "${Get.find<UserController>().userInfoModel.phone != null ?  Get.find<UserController>().userInfoModel.phone!.contains('null') ? '':Get.find<UserController>().userInfoModel.phone:''},".tr,):SizedBox(),
      buildSimpleText(title: '', value: "${Get.find<SplashController>().configModel.content!.footerText != null ? Get.find<SplashController>().configModel.content!.footerText! : null}"),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

   static Widget buildInvoiceImage(var netImage,BookingDetailsContent bookingDetailsContent,Invoice invoice) {
     return Column(
         children: [
           SizedBox(height: 1 * PdfPageFormat.cm),
           Row(
               children: [
                 Container(
                   width: Dimensions.INVOICE_IMAGE_WIDTH,
                   height: Dimensions.INVOICE_IMAGE_HEIGHT,
                   child: pw.Image(netImage),),
                 SizedBox(width: 15),
                 Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(Get.find<SplashController>().configModel.content!.businessName!,
                           style: TextStyle(fontSize: 22,color: PdfColor.fromHex("F58F2A")
                           )
                       ),
                       Text(Get.find<SplashController>().configModel.content!.businessAddress!),
                       Text(Get.find<SplashController>().configModel.content!.businessPhone!),
                     ]
                 )
               ]
           ),


         ]
     );
   }
}
