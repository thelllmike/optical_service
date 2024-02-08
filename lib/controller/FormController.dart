import 'package:flutter/material.dart';

class FormController {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nicNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController fittingChargesController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  TextEditingController advancePaidController = TextEditingController();
  TextEditingController balanceAmountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  // final TextEditingController _quantityController = TextEditingController(text: "1");

  // Add other controllers if needed

  // You can also add validation logic or getters to access controller values here

  void dispose() {
    mobileNumberController.dispose();
    fullNameController.dispose();
    nicNumberController.dispose();
    addressController.dispose();
    totalAmountController.dispose();
    discountController.dispose();
    fittingChargesController.dispose();
    grandTotalController.dispose();
    advancePaidController.dispose();
    balanceAmountController.dispose();
     quantityController.dispose();
    priceController.dispose();
    // _quantityController.dispose();
    // Dispose other controllers
  }
}
