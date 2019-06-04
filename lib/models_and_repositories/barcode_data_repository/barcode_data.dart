import 'package:equatable/equatable.dart';

class BarcodeData extends Equatable {
  final double price;
  final int count;
  final int checkoutCount;
  final String barcodeNumber;
  final String productName;
  final String category;
  // final String manufacturer;
  final String brand;
  // final List<String> images;
  final List<int> imageBytes;
  // final List<int> thumbnailBytes;

  BarcodeData(
      {this.count,
      this.checkoutCount,
      this.price,
      this.barcodeNumber,
      this.productName,
      this.category,
      // this.manufacturer,
      this.brand,
      // this.images,
      this.imageBytes,
      // this.thumbnailBytes
      })
      : super([
          count,
          checkoutCount,
          price,
          barcodeNumber,
          productName,
          category,
          // manufacturer,
          brand,
          // images,
          // imageBytes,
        ]);

  BarcodeData.onlyBarcode({
    this.barcodeNumber
    }):brand = 'Brand',
    checkoutCount = 0,
    count = 1,
    price = 0.0,
    productName = 'Name',
    category = 'Category',
    // manufacturer = 'Manufacture',
    // images = null,
    imageBytes = null;
    // thumbnailBytes = null;

  static BarcodeData fromJson(dynamic json) {
    final product = json['products'][0];
    return BarcodeData(
      count: 1,
      checkoutCount: 1,
      price: 0.0,
      barcodeNumber: product['barcode_number'],
      brand: product['brand'],
      category: product['category'],
      // manufacturer: product['manufacturer'],
      // images: product['images'],
      productName: product['product_name'],
      // imageBytes: [],
    );
  }

  static BarcodeData fromList(List list) => BarcodeData(
        price: 1.0,
        count: 1,
        checkoutCount: 1,
        productName: list[0],
        brand: list[1],
        // manufacturer: list[2],
        category: list[2],
        // images: [list[4]],
        imageBytes: list[3],
        // thumbnailBytes: list[6],
        barcodeNumber: list[4]
      );

  static Map<String, dynamic> toMap(BarcodeData barcodeData) => {
        'barcode': barcodeData.barcodeNumber,
        'count': barcodeData.count,
        'price': barcodeData.price,
        'brand': barcodeData.brand,
        'name': barcodeData.productName,
        'category': barcodeData.category,
        // 'image': barcodeData.images[0],
        // 'imageBytes': barcodeData.imageBytes.toList(),
      };

  BarcodeData copyWith({
    double price,
    int count,
    int checkoutCount,
    String barcodeNumber,
    String productName,
    String category,
    // String manufacturer,
    String brand,
    List<String> images,
    List<int> imageBytes,
  })=>BarcodeData(
    price: price ?? this.price,
    count: count ?? this.count,
    checkoutCount: checkoutCount ?? this.checkoutCount,
    barcodeNumber: barcodeNumber ?? this.barcodeNumber,
    productName: productName ?? this.productName,
    category: category ?? this.category,
    // manufacturer: manufacturer ?? this.manufacturer,
    brand: brand ?? this.brand,
    imageBytes: imageBytes ?? this.imageBytes,
    // images: images ?? this.images,
  );

  bool get hasNoNull => 
    price != null
    && count != null
    // && checkoutCount != null
    && barcodeNumber != null
    && productName != null
    && category != null
    // && manufacturer != null
    && brand != null
    && imageBytes != null;
    // && images != null;
  
}
