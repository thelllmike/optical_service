class Invoice {
  final String invoiceDate;
  final String customerName;
  final String mobileNumber;
  final String salesPerson;
  final String lensCategory;
  final String frameBrand;
  final double advancePaid;
  final double grandTotal;
  final double balanceAmount;
  final String payType;

  Invoice({
    required this.invoiceDate,
    required this.customerName,
    required this.mobileNumber,
    required this.salesPerson,
    required this.lensCategory,
    required this.frameBrand,
    required this.advancePaid,
    required this.grandTotal,
    required this.balanceAmount,
    required this.payType,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceDate: json['invoice_date'],
      customerName: json['customer_name'],
      mobileNumber: json['mobile_number'],
      salesPerson: json['sales_person'],
      lensCategory: json['lens_category'],
      frameBrand: json['frame_brand'],
      advancePaid: json['advance_paid'].toDouble(),
      grandTotal: json['grand_total'].toDouble(),
      balanceAmount: json['balance_amount'].toDouble(),
      payType: json['pay_type'],
    );
  }
}
