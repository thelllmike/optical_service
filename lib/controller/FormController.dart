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
  

  // Private controllers
  TextEditingController _invoiceDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();
  TextEditingController _salesPersonController = TextEditingController();

  // Public getters for private controllers
  TextEditingController get invoiceDateController => _invoiceDateController;
  TextEditingController get deliveryDateController => _deliveryDateController;
  TextEditingController get salesPersonController => _salesPersonController;

   int? customerId;

  // Dispose method to clean up controllers
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
    _invoiceDateController.dispose();
    _deliveryDateController.dispose();
    _salesPersonController.dispose();
 
  }
}
