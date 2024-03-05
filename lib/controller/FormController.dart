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
  TextEditingController frameQuantityController = TextEditingController();

  TextEditingController _invoiceDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();
  TextEditingController _salesPersonController = TextEditingController();

  int? customerId;

  int? billingId;

  FormController() {
    // Add listeners to controllers that affect calculations
    totalAmountController.addListener(calculateTotals);
    discountController.addListener(calculateTotals);
    fittingChargesController.addListener(calculateTotals);
    advancePaidController.addListener(calculateTotals);
    // You can add more listeners if any other fields affect the calculation
  }

  // Public getters for private controllers
  TextEditingController get invoiceDateController => _invoiceDateController;
  TextEditingController get deliveryDateController => _deliveryDateController;
  TextEditingController get salesPersonController => _salesPersonController;
TextEditingController payTypeController = TextEditingController(text: "Cash");
  void calculateTotals() {
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;
    double fittingCharges = double.tryParse(fittingChargesController.text) ?? 0;
    double advancePaid = double.tryParse(advancePaidController.text) ?? 0;

    // Calculate grand total
    double grandTotal = (totalAmount - discount + fittingCharges);
    grandTotalController.text = grandTotal.toStringAsFixed(2);

    // Calculate balance amount
    double balanceAmount = grandTotal - advancePaid;
    balanceAmountController.text = balanceAmount.toStringAsFixed(2);
  }

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
    frameQuantityController.dispose();
    _invoiceDateController.dispose();
    _deliveryDateController.dispose();
    _salesPersonController.dispose();
  }
}
