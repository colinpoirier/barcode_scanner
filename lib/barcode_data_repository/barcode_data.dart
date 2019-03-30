import 'package:equatable/equatable.dart';

class BarcodeData extends Equatable {
  final String barcodeNumber;
  final String barcodeType;
  final String barcodeFormats;
  final String mpn;
  final String model;
  final String asin;
  final String productName;
  final String title;
  final String category;
  final String manufacturer;
  final String brand;
  final String label;
  final String ingredients;
  final String nutritionFacts;
  final String color;
  final String format;
  final String packageQuantity;
  final String size;
  final String length;
  final String width;
  final String height;
  final String weight;
  final String releaseDate;
  final String description;
  final List<String> images;

  BarcodeData({
      this.barcodeNumber,
      this.barcodeType,
      this.barcodeFormats,
      this.mpn,
      this.model,
      this.asin,
      this.productName,
      this.title,
      this.category,
      this.manufacturer,
      this.brand,
      this.label,
      this.ingredients,
      this.nutritionFacts,
      this.color,
      this.format,
      this.packageQuantity,
      this.size,
      this.length,
      this.width,
      this.height,
      this.weight,
      this.releaseDate,
      this.description,
      this.images}):super([
        barcodeNumber,
        barcodeType,
        barcodeFormats,
        mpn,
        model,
        asin,
        productName,
        title,
        category,
        manufacturer,
        brand,
        label,
        ingredients,
        nutritionFacts,
        color,
        format,
        packageQuantity,
        size,
        length,
        width,
        height,
        weight,
        releaseDate,
        description,
        images,
      ]);

  static BarcodeData fromJson(dynamic json){
    final product = json['products'][0];
    return BarcodeData(
      asin: product['asin'],
      barcodeFormats: product['barcode_formats'],
      barcodeNumber: product['barcode_number'],
      barcodeType: product['barcode_type'],
      brand: product['brand'],
      category: product['category'],
      color: product['color'],
      description: product['description'],
      releaseDate: product['release_date'],
      manufacturer: product['manufacturer'],
      model: product['model'],
      mpn: product['mpn'],
      label: product['label'],
      format: product['format'],
      nutritionFacts: product['nutrition_facts'],
      size: product['size'],
      length: product['length'],
      width: product['width'],
      height: product['height'],
      weight: product['weight'],
      images: product['images'],
      packageQuantity: product['package_quantity'],
      productName: product['product_name'],
      ingredients: product['ingredients'],
      title: product['title'],
    );
  }
}
