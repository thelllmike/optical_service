import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';
import 'package:optical_desktop/requesthadleing/customer.dart';
import 'package:optical_desktop/requesthadleing/deliverydate.dart';
import 'package:optical_desktop/requesthadleing/Prescription.dart';
import 'package:optical_desktop/requesthadleing/billing_items.dart';
import 'package:optical_desktop/requesthadleing/updatestock.dart';
import 'package:optical_desktop/requesthadleing/payment_details_service.dart';
import 'package:optical_desktop/requesthadleing/print.dart';
import 'package:optical_desktop/controller/FormController.dart';
import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// import 'package:optical_desktop/requesthadleing/lensDropdown.dart';
import 'package:optical_desktop/global.dart' as globals;

final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.dark());

class Item {
  String description;
  int quantity;
  double unitPrice;

  Item(
      {required this.description,
      required this.quantity,
      required this.unitPrice});

  double get totalAmount => quantity * unitPrice;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: _themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: BillScreen(),
        );
      },
    );
  }
}

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final FormController _formController = FormController();
  List<String> frames = [];
  List<String> brands = [];
  List<String> sizes = [];
  List<String> models = [];
  List<String> colors = [];

  List<String> _lensCategories = [];
  List<String> _coatings = [];
  List<String> _powers = [];

  String? _selectedCategory;

  double totalPrice = 0.0; // Total price
  double selectedPrice = 0.0; // Unit price of the selected model

  String? selectedFrame;
  String? selectedBrand;
  String? selectedSize;
  String? selectedColor; // Define a state variable for the selected color
  String? selectedModel;
  String? _selectedGender; // Declare this at the class level
  final TextEditingController _quantityController =
      TextEditingController(text: "1");
//  final FormController formController = FormController();
  // String? selectedLensCategory;
  String? _selectedCoating;
  String? _selectedPower;

  Map<String, String> _formData = {
    'R_SPH': '',
    'R_CYL': '',
    'R_AXIS': '',
    'R_ADD': '',
    'L_SPH': '',
    'L_CYL': '',
    'L_AXIS': '',
    'L_ADD': '',
  };

  bool isLoadingPowers = false;

  double _quantity = 1; // Default quantity
  double _lensPrice = 0.0; // Unit price of the lens

  Map<String, TextEditingController> _controllers = {};
  DateTime _selectedDate = DateTime.now();
  List<Item> items = [
    Item(description: 'Item 1', quantity: 1, unitPrice: 10.0)
  ];
  bool _isSidebarVisible = false;
  //create random invoice id
   late String invoiceId;

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFramesData();
    _fetchLensCategories();
    _quantityController.addListener(_onQuantityChanged);
    _formController.mobileNumberController
        .addListener(_onMobileNumberSubmitted);
    // _updateTotalAmountDirectly();
    // invoiceId = _generateInvoiceId(int length);
  }

 String _generateInvoiceId(int length) {
  const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

  @override
  void dispose() {
    // Make sure to dispose of the form controller
    _formController.dispose();
    _quantityController.dispose();

    // formController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    _calculateAndDisplayTotalPrice();
  }

  void _calculateAndDisplayTotalPrice() {
    if (_selectedCategory != null &&
        _selectedCoating != null &&
        _selectedPower != null &&
        _selectedPower!.isNotEmpty) {
      fetchLensPriceBySelection(
        category: _selectedCategory!,
        coating: _selectedCoating!,
        power: double.tryParse(_selectedPower!) ?? 0.0,
        branchId: globals.branch_id,
      ).then((result) {
        setState(() {
          if (result.containsKey('price')) {
            _lensPrice = double.tryParse(result['price']) ?? 0.0;
          } else {
            // Handle error or default case
            _lensPrice = 0.0;
          }
          _updateTotalAmount();
        });
      });
    }
  }

//get customer details to the input fields
  void _onMobileNumberSubmitted() {
    if (_formController.mobileNumberController.text.isNotEmpty) {
      _fetchCustomerDetails(_formController.mobileNumberController.text);
    }
  }

  ///lensdropdown/onlycategory
  Future<List<String>> fetchLensCategories(int branch_id) async {
    final uri = Uri.parse(
        'http://localhost:8001/lensdropdown/onlycategory?branch_id=$branch_id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = json.decode(response.body);
      return categoriesJson.cast<String>();
    } else {
      print('Error fetching categories: ${response.statusCode}');
      return [];
    }
  }

  Future<List<String>> fetchCoatingsByCategory(
      String category, int branchId) async {
    final uri = Uri.parse(
        'http://localhost:8001/lensdropdown/coatings-by-category?category=$category&branch_id=$branchId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> coatingsJson = json.decode(response.body);
      return coatingsJson.cast<String>();
    } else {
      print('Error fetching coatings: ${response.statusCode}');
      return [];
    }
  }

  Future<void> _fetchCoatingsForCategory(String category) async {
    // Simulate fetching coatings data. Replace with your actual fetching logic
    List<String> fetchedCoatings =
        await fetchCoatingsByCategory(category, globals.branch_id);
    setState(() {
      _coatings = fetchedCoatings;
      // Optionally, set the first coating as selected by default
      if (_coatings.isNotEmpty) {
        _selectedCoating = _coatings.first;
      }
    });
  }

  void _onLensCategorySelected(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedCategory = newValue;
      _selectedCoating = null; // Reset selected coating when category changes
      _selectedPower = null; // Optionally reset selected power too
      _coatings = []; // Reset coatings list
      _powers = []; // Reset powers list
    });
    _fetchCoatingsForCategory(newValue);
  }

  Future<void> _fetchLensCategories() async {
    try {
      int branch_id = globals.branch_id; // Ensure this is correctly initialized
      List<String> categories = await fetchLensCategories(branch_id);
      setState(() {
        _lensCategories = categories;
      });
    } catch (e) {
      // Handle the error, possibly by showing an error message or logging
      print('Error fetching lens categories: $e');
    }
  }

  Widget _buildLensCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (String? newValue) async {
        if (newValue != null) {
          // Update the state to reflect the new selected category
          setState(() {
            _selectedCategory = newValue;
            _coatings
                .clear(); // Optionally clear coatings when category changes
            _selectedCoating = null; // Reset selected coating
            _powers.clear(); // Optionally clear powers when category changes
            _selectedPower = null; // Reset selected power
          });
          // Fetch new coatings based on the selected category
          await _fetchCoatingsForCategory(newValue);
          // You can also directly call to fetch powers if required here,
          // but usually, you would fetch powers after a coating is selected
        }
      },
      items: _lensCategories.map<DropdownMenuItem<String>>((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Lens Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }

  //drodown fetch by power
  ///lensdropdown/powers-by-category-and-coating
  Future<List<String>> fetchPowersByCategoryAndCoating(
      String category, String coating, int branchId) async {
    final uri = Uri.parse(
            'http://localhost:8001/lensdropdown/powers-by-category-and-coating')
        .replace(queryParameters: {
      'category': category,
      'coating': coating,
      'branch_id': branchId.toString(),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response and ensure numbers are converted to strings
        final List<dynamic> powersJson = json.decode(response.body);
        // Use .map() to convert each element to a string, handling numbers correctly
        List<String> powers =
            powersJson.map((dynamic value) => value.toString()).toList();
        return powers;
      } else {
        // Log or handle HTTP errors here
        print('Error fetching powers: HTTP ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle any kind of exception here, not just HTTP exceptions
      print('Error fetching powers: $e');
      return [];
    }
  }

//fetch by categoty ,coating an dpower
  Future<Map<String, dynamic>> fetchLensPriceBySelection({
    required String category,
    required String coating,
    required double power,
    required int branchId,
  }) async {
    final uri =
        Uri.parse('http://localhost:8001/lensdropdown/lens-price-by-selection')
            .replace(queryParameters: {
      'category': category,
      'coating': coating,
      'power': power.toString(),
      'branch_id': branchId.toString(),
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return {
          'lensId': jsonResponse['id'],
          'price': jsonResponse['price'].toString(),
        };
      } else {
        print('Error fetching price: ${response.statusCode}');
        // Return an error map or default values
        return {'error': 'Error fetching price', 'lens_id': 0, 'price': '0.0'};
      }
    } catch (e) {
      print('Exception when fetching price: $e');
      // Return an error map or default values
      return {
        'error': 'Exception when fetching price',
        'lens_id': 0,
        'price': '0.0'
      };
    }
  }

  ///dropdown/models-by-selection

  Future<void> _fetchModelsBySelection(
      String frame, String brand, String size, String color) async {
    try {
      // Construct the URL with the branch_id query parameter
      final queryParameters = {
        'frame': frame,
        'brand': brand,
        'size': size,
        'color': color,
        'branch_id': globals.branch_id
            .toString(), // Converting int to String to be used in URL
      };
      final uri = Uri.http(
          'localhost:8001', '/dropdown/models-by-selection', queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> fetchedModels =
            List<String>.from(json.decode(response.body));

        setState(() {
          models = fetchedModels;
        });
      } else {
        // Handle the error; maybe show a message to the user
        print('Error fetching models: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
      print('Network Error: $e');
    }
  }

  Future<void> _fetchFramesData() async {
    try {
      // Construct the URL with the branch_id query parameter
      final url = Uri.parse('http://localhost:8001/dropdown/onlyframe').replace(
          queryParameters: {'branch_id': globals.branch_id.toString()});

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<String> fetchedFrames = (json.decode(response.body) as List)
            .map((data) =>
                data.toString()) // Assuming the API returns a list of strings
            .toList();

        setState(() {
          frames = fetchedFrames;
        });
      } else {
        // Handle the error; maybe show a message to the user
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
    }
  }

  ///dropdown/brands-by-frame
  ///filter by frames which we selected

  Future<void> _fetchBrandsByFrame(String frame) async {
    try {
      // Include the branch_id in the query parameters
      final queryParameters = {
        'frame': frame,
        'branch_id': globals.branch_id
            .toString(), // Converting int to String to be used in URL
      };
      final uri = Uri.http(
          'localhost:8001', '/dropdown/brands-by-frame', queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> fetchedBrands =
            List<String>.from(json.decode(response.body));

        setState(() {
          brands = fetchedBrands;
        });
      } else {
        // Handle the error; maybe show a message to the user
        print('Error fetching brands: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
      print('Network Error: $e');
    }
  }

//filtered bybrand and frame and get details
  ///dropdown/sizes-by-frame-and-brand
  ///

  Future<void> _fetchSizesByFrameAndBrand(String frame, String brand) async {
    try {
      // Construct the URL with the branch_id query parameter
      final queryParameters = {
        'frame': frame,
        'brand': brand,
        'branch_id': globals.branch_id
            .toString(), // Converting int to String to be used in URL
      };
      final uri = Uri.http('localhost:8001',
          '/dropdown/sizes-by-frame-and-brand', queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> fetchedSizes =
            List<String>.from(json.decode(response.body));

        setState(() {
          sizes = fetchedSizes;
        });
      } else {
        // Handle the error; maybe show a message to the user
        print('Error fetching sizes: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
      print('Network Error: $e');
    }
  }

  Future<void> _fetchColorsByFrameBrandSize(
      String frame, String brand, String size) async {
    try {
      // Construct the URL with the branch_id query parameter
      final queryParameters = {
        'frame': frame,
        'brand': brand,
        'size': size,
        'branch_id': globals.branch_id
            .toString(), // Converting int to String to be used in URL
      };
      final uri = Uri.http('localhost:8001',
          '/dropdown/colors-by-frame-brand-size', queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<String> fetchedColors =
            List<String>.from(json.decode(response.body));

        setState(() {
          colors = fetchedColors;
        });
      } else {
        // Handle the error; maybe show a message to the user
        print('Error fetching colors: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
      print('Network Error: $e');
    }
  }

  Future<Map<String, String>> fetchPriceBySelection(String frame, String brand,
      String size, String color, String model) async {
    // Construct the URL with the branch_id query parameter
    final queryParameters = {
      'frame': frame,
      'brand': brand,
      'size': size,
      'color': color,
      'model': model,
      'branch_id':
          globals.branch_id.toString(), // Assuming globals.branch_id is an int
    };
    final uri = Uri.http(
        'localhost:8001', '/dropdown/price-by-selection', queryParameters);

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // Assuming 'id' is also a key in the jsonResponse
        String priceString = jsonResponse['price'].toString();
        String idString = jsonResponse['id'].toString();
        print(
            "Price and ID received: $priceString, $idString"); // Print the received data
        return {
          'frameId': idString,
          'price': priceString,
        };
      } else {
        // Handle the error; maybe show a message to the user
        print("Error fetching data: ${response.body}");
        return {
          'error': "Error fetching data",
          'errorMessage': response.body,
        };
      }
    } catch (e) {
      print("Exception caught: $e");
      return {
        'error': "Exception caught",
        'errorMessage': e.toString(),
      };
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

//customer details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optical Service'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _themeNotifier.value =
                  (_themeNotifier.value.brightness == Brightness.dark)
                      ? ThemeData.light()
                      : ThemeData.dark();
            },
          )
        ],
      ),
      body: Row(
        children: [
          Sidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle save & print logic here
           invoiceId = _generateInvoiceId(6);
          _submitCustomerForm();
        },
        child: Icon(Icons.print),
        tooltip: 'Save & Print (F12)',
      ),
    );
  }

  //print details

  void _printBillingDetails() async {
    final PrintHelper printHelper = PrintHelper();

    // Gather customer and invoice details
    String customerName = _formController.fullNameController.text;
    String customerPhone = _formController.mobileNumberController.text;
    String invoiceDate = _formController.invoiceDateController.text;
    String invoiceNumber =
        invoiceId; // You might want to generate this programmatically or fetch it from a database

    // Generate the item details list
    List<Map<String, dynamic>> itemDetails = items
        .map((item) => {
              'description': item.description,
              'quantity': item.quantity,
              'unitPrice': item.unitPrice,
              'total': item.totalAmount,
            })
        .toList();

    // Assuming you have a map `_formData` with all prescription fields
    List<Map<String, dynamic>> prescriptionDetails = [
      {
        'Eye': 'R',
        'PD': _formData[
            'R_PD'], // Assuming you have R_PD in your form data for right PD
        'SPH': _formData['R_SPH'], // Sphere for the right eye
        'CYL': _formData['R_CYL'], // Cylinder for the right eye
        'AXIS': _formData['R_AXIS'], // Axis for the right eye
        'ADD': _formData['R_ADD'], // Addition for the right eye, if applicable
      },
      {
        'Eye': 'L',
        'PD': _formData[
            'L_PD'], // Assuming you have L_PD in your form data for left PD
        'SPH': _formData['L_SPH'], // Sphere for the left eye
        'CYL': _formData['L_CYL'], // Cylinder for the left eye
        'AXIS': _formData['L_AXIS'], // Axis for the left eye
        'ADD': _formData['L_ADD'], // Addition for the left eye, if applicable
      },
    ];

    try {
      double total =
          double.tryParse(_formController.totalAmountController.text) ?? 0.0;
      double advancePaid =
          double.tryParse(_formController.advancePaidController.text) ?? 0.0;

      // Specify the logo asset path relative to your assets directory
      String logoAssetPath =
          'assets/logo.png'; // Ensure this file is included in your pubspec.yaml under assets

      final pdf = await printHelper.generateDocument(
        logoAssetPath:
            logoAssetPath, // Updated to use logoAssetPath for clarity
        branchName: 'Branch Name',
        branchAddress: 'Branch Address',
        mobileNumber: 'Branch Phone Number',
        customerName: customerName,
        customerPhone: customerPhone,
        invoiceDate: invoiceDate,
        invoiceNumber: invoiceNumber,
        itemDetails: itemDetails,
        prescriptionDetails: prescriptionDetails,
        total: total,
        advancePaid: advancePaid,
        takenBy: 'Sales',
      );

      print("Total: $total, Advance Paid: $advancePaid"); // Debugging

      String fileName = "Invoice_$invoiceNumber.pdf";
      await printHelper.printAndSaveDocument(pdf, fileName);

      print("Document should have been printed and saved as $fileName");
    } catch (e) {
      print("An error occurred while printing or saving the document: $e");
    }
  }

  void _submitCustomerForm() async {
    String mobileNumber = _formController.mobileNumberController.text.trim();
    String fullName = _formController.fullNameController.text.trim();
    String nicNumber = _formController.nicNumberController.text.trim();
    String address = _formController.addressController.text.trim();
    String gender = _selectedGender ?? 'Not Specified';

    String? validationResult =
        _validateForm(mobileNumber, fullName, nicNumber, address, gender);
    if (validationResult != null) {
      _showValidationAlert(validationResult);
      return; // Validation failed, stop execution
    }
    try {
      // Attempt to fetch existing customer ID based on mobile number
      int? customerId =
          await CustomerService.fetchCustomerDetails(mobileNumber);

      if (customerId == null) {
        // If customer does not exist, attempt to create a new one
        customerId = await CustomerService.createNewCustomer(
          mobileNumber: mobileNumber,
          fullName: fullName,
          nicNumber: nicNumber,
          address: address,
          gender: gender,
        );

        if (customerId == null) {
          print('Failed to create new customer.');
          return; // Stop execution if failed to create new customer
        }
      }

      _formController.customerId = customerId;
      var billingResult = await _submitForm();
      // Finally, submit prescription details if needed
      _submitPrescriptionDetails(customerId);

      int? billingId = billingResult['billingId'];
      if (billingId == null) {
        print('Billing ID not found.');
        return;
      }

//here need to update

      // Fetch frame ID
      var frameResult = await fetchPriceBySelection(
          selectedFrame!,
          selectedBrand!,
          selectedSize!,
          selectedColor!,
          selectedModel!); // Ensure this method correctly handles null and type issues

      int? frameId = int.tryParse(frameResult['frameId']?.toString() ?? '');
      if (frameId == null) {
        print('Failed to parse frameId.');
        return;
      }
      _printBillingDetails();
      // Fetch lens ID
      var lensResult = await fetchLensPriceBySelection(
        category: _selectedCategory!,
        coating: _selectedCoating!,
        power: double.tryParse(_selectedPower!) ?? 0.0,
        branchId: globals.branch_id,
      ); // Ensure this method correctly handles null and type issues

      int? lensId = int.tryParse(lensResult['lensId']?.toString() ?? '');
      if (lensId == null) {
        print('Failed to parse lensId.');
        return;
      }

      // Assume both frameQty and lensQty are correctly parsed as integers
      int frameQty =
          int.tryParse(_formController.frameQuantityController.text) ?? 1;
      int lensQty = int.tryParse(_quantityController.text) ?? 1;

      // Submit the billing item with obtained IDs
      await submitBillingItem(
        billingId: billingId,
        lensId: lensId,
        frameId: frameId,
        frameQty: frameQty,
        lensQty: lensQty,
      );

       // Assuming LensService is correctly set up to update the stock
    final UpdateStockService updateStockService = UpdateStockService();
    // Call updateLensStock for the lens ID with the quantity
    // Here, lensQty is used as an example; adjust as needed for your use case
  try {
  await Future.wait([
    updateStockService.updateLensStock(lensId, lensQty),
    updateStockService.updateFrameStock(frameId, frameQty),
  ]);
  print("All stock updates successfully completed.");
} catch (error) {
  print("An error occurred during stock updates: $error");
}



      _submitPaymentDetails(billingId);
      _printBillingDetails();
    } catch (e) {
      print('An error occurred while submitting the form: $e');
    }
  }

// Accept customerId as a parameter
  void _submitPrescriptionDetails(int customerId) async {
    Prescription newPrescription = Prescription(
      customer_id: customerId, // Use the passed customerId
      rightPd: _formData['R_PD']!, // Pupillary Distance for the right eye
      rightSph: _formData['R_SPH']!, // Sphere for the right eye
      rightCyl: _formData['R_CYL']!, // Cylinder for the right eye
      rightAxis: _formData['R_AXIS']!, // Axis for the right eye
      rightAdd:
          _formData['R_ADD']!, // Addition for the right eye, if applicable
      leftPd: _formData['L_PD']!, // Pupillary Distance for the left eye
      leftSph: _formData['L_SPH']!, // Sphere for the left eye
      leftCyl: _formData['L_CYL']!, // Cylinder for the left eye
      leftAxis: _formData['L_AXIS']!, // Axis for the left eye
      leftAdd: _formData['L_ADD']!, // Addition for the left eye, if applicable
    );

    bool result = await PrescriptionService.submitPrescription(
        prescription: newPrescription);
    if (result) {
      print("Prescription submitted successfully");
    } else {
      print("Failed to submit prescription");
    }
  }

  void _submitPaymentDetails(int billingId) async {
    double totalAmount =
        double.tryParse(_formController.totalAmountController.text) ?? 0.0;
    double discount =
        double.tryParse(_formController.discountController.text) ?? 0.0;
    double fittingCharges =
        double.tryParse(_formController.fittingChargesController.text) ?? 0.0;
    double grandTotal =
        double.tryParse(_formController.grandTotalController.text) ?? 0.0;
    double advancePaid =
        double.tryParse(_formController.advancePaidController.text) ?? 0.0;
    double balanceAmount =
        double.tryParse(_formController.balanceAmountController.text) ?? 0.0;
    String payType =
        "Cash"; // Assuming this is selected from a dropdown or another input widget in your UI

    bool success = await PaymentDetailsService.submitPaymentDetails(
      billingId: billingId,
      totalAmount: totalAmount,
      discount: discount,
      fittingCharges: fittingCharges,
      grandTotal: grandTotal,
      advancePaid: advancePaid,
      balanceAmount: balanceAmount,
      payType: payType,
    );

    if (success) {
      print('Payment details submitted successfully');
      // Handle successful submission (e.g., navigate to a confirmation screen)
    } else {
      print('Failed to submit payment details');
      // Handle failure (e.g., show an error message)
    }
  }

  Future<Map<String, dynamic>> _submitForm() async {
    if (_formController.customerId == null) {
      print('Customer ID is null. Cannot proceed with billing submission.');
      return {
        'success': false,
        'message': 'Customer ID is null',
        'billingId': null
      };
    }

    var result = await DeliveryDateService.submitBilling(
      invoiceDate: _formController.invoiceDateController.text.trim(),
      deliveryDate: _formController.deliveryDateController.text.trim(),
      salesPerson: _formController.salesPersonController.text.trim(),
      customerId: _formController.customerId!,
    );

    if (result['success'] == true) {
      int? billingId = int.tryParse(result['billingId'].toString());
      // Log or use billingId as required
      print("Billing submission successful with ID: $billingId");
      return {
        'success': true,
        'message': 'Billing submission successful',
        'billingId': billingId
      };
    } else {
      print(result['error'] ??
          'Unknown error occurred during billing submission.');
      return {
        'success': false,
        'message': result['error'] ?? 'Error during billing submission',
        'billingId': null
      };
    }
  }

// This function remains focused on validation logic.
  String? _validateForm(String mobileNumber, String fullName, String nicNumber,
      String address, String gender) {
    final mobileNumberPattern = RegExp(r'^07[01245678][0-9]{7}$');
    // final nicNumberPattern = RegExp(r'^[0-9]{9}[vVxX]$');

    if (mobileNumber.isEmpty) {
      return "Mobile number is required.";
    } else if (fullName.isEmpty) {
      return "Full name is required.";
    } else if (address.isEmpty) {
      return "Address is required.";
    } else if (gender.isEmpty) {
      return "Gender is required.";
    }

    if (!mobileNumberPattern.hasMatch(mobileNumber)) {
      return "Invalid mobile number format.";
    }
    return null;
  }

  void _showValidationAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validation Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      {String? value, required Function(String) onSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          isDense: true,
        ),
        value: value, // Set the current value for the dropdown
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onSelected(newValue);
          }
        },
        style: TextStyle(fontSize: 10),
        isExpanded: true,
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCustomerDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(child: _buildFrameDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(
                    child: _buildInvoiceAndDeliveryDetailsSection(), flex: 1),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLensDetailsSection(), flex: 1),
                SizedBox(width: 8),
                // Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                // Expanded(child: _buildPaymentDetailsSection(), flex: 1),
                //table
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildItemTable(), flex: 1),
                SizedBox(width: 8),
                // Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(child: _buildPaymentDetailsSection(), flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // This method builds the prescription details section
  Widget _buildPrescriptionDetailsSection() {
    return _buildDetailsCard('Prescription Details', [
      _buildEditableTable(),
    ]);
  }

  Widget _buildEditableCell(String key) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _formData[key] = value;
          });
        },
      ),
    );
  }

  Widget _buildCustomerDetailsSection() {
    return _buildDetailsCard('Customer Details', [
      _buildCustomerDetailTextField(
        'Mobile Number',
        _formController.mobileNumberController,
        onSubmitted: (value) => _onMobileNumberSubmitted(),
      ),
      _buildCustomerDetailTextField(
          'Full Name', _formController.fullNameController),
      _buildCustomerDetailTextField(
          'NIC Number', _formController.nicNumberController),
      _buildCustomerDetailTextField(
          'Address', _formController.addressController,
          maxLines: 3),
      _buildGenderDropdown()
      // Other widgets as needed
    ]);
  }

// Ensure this is defined only once in your codebase
  Widget _buildCustomerDetailTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    Function(String)? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16), // Adjusted label font size
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(4.0), // Rounded corners for the border
            borderSide: BorderSide(width: 1), // Adjusted border thickness
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0), // Adjusted padding inside the text field
        ),
        style: TextStyle(fontSize: 14), // Adjusted text font size
        maxLines: maxLines,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }

  ///billing/customers/by-phone/{phone_number}
  Future<int?> _fetchCustomerDetails(String mobileNumber) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8001/billing/customers/by-phone/$mobileNumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Ensure the keys exactly match those in your received JSON data
      _formController.fullNameController.text = data['full_name'] ?? '';
      _formController.nicNumberController.text = data['nic_number'] ?? '';
      _formController.addressController.text = data['address'] ?? '';
      // Update the UI if needed
      setState(() {});
      // Update your gender dropdown based on the response, if necessary
    } else {
      print('Customer not found or error fetching customer details.');
      // return null; // Return null if customer doesn't exist
    }
    return null;
  }

  Widget _buildGenderDropdown() {
    return DropdownButton<String>(
      value: _selectedGender,
      hint: Text('Select Gender'),
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
    );
  }

  Widget _buildReadOnlyTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
        readOnly: true, // Make this field read-only
      ),
    );
  }

//quntity frame
  Widget _buildQuantityField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        controller:
            _formController.frameQuantityController, // Corrected reference
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          isDense: true,
        ),
        maxLines: maxLines,
        onChanged: (quantity) {
          int qty = 1;
          if (quantity.isNotEmpty) {
            try {
              qty = int.parse(quantity);
            } catch (e) {
              // Handle error for invalid input
            }
          }
          setState(() {
            totalPrice =
                qty * selectedPrice; // Calculate and update total price
          });
        },
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildFrameDetailsSection() {
    return _buildDetailsCard('Frame Details', [
      // Frame Dropdown
      _buildDropdownField(
        'Frame',
        frames,
        value: selectedFrame,
        onSelected: (newValue) {
          setState(() {
            selectedFrame = newValue;
            selectedBrand = null; // Reset brand when frame changes
            selectedSize = null; // Reset size when frame changes
            selectedColor = null; // Reset color when frame changes
            selectedModel = null; // Reset model when frame changes
            brands = []; // Clear previous brands
            sizes = []; // Clear previous sizes
            colors = []; // Clear previous colors
            models = []; // Clear previous models
          });
          _fetchBrandsByFrame(newValue);
        },
      ),

      // Brand Dropdown
      _buildDropdownField(
        'Brand',
        brands,
        value: selectedBrand,
        onSelected: (newValue) {
          setState(() {
            selectedBrand = newValue;
            selectedSize = null; // Reset size when brand changes
            selectedColor = null; // Reset color when brand changes
            selectedModel = null; // Reset model when brand changes
            sizes = []; // Clear previous sizes
            colors = []; // Clear previous colors
            models = []; // Clear previous models
          });
          if (selectedFrame != null) {
            _fetchSizesByFrameAndBrand(selectedFrame!, newValue);
          }
        },
      ),

      // Size Dropdown
      _buildDropdownField(
        'Size',
        sizes,
        value: selectedSize,
        onSelected: (newValue) {
          setState(() {
            selectedSize = newValue;
            selectedColor = null; // Reset color when size changes
            selectedModel = null; // Reset model when size changes
            colors = []; // Clear previous colors
            models = []; // Clear previous models
          });
          if (selectedFrame != null && selectedBrand != null) {
            _fetchColorsByFrameBrandSize(
                selectedFrame!, selectedBrand!, newValue);
          }
        },
      ),

      // Color Dropdown
      _buildDropdownField(
        'Color',
        colors,
        value: selectedColor,
        onSelected: (newValue) {
          setState(() {
            selectedColor = newValue;
            selectedModel = null; // Reset model when color changes
            models = []; // Clear previous models
          });
          if (selectedFrame != null &&
              selectedBrand != null &&
              selectedSize != null) {
            _fetchModelsBySelection(
                selectedFrame!, selectedBrand!, selectedSize!, newValue);
          }
        },
      ),

      // Model Dropdown
      _buildDropdownField(
        'Model',
        models,
        value: selectedModel,
        onSelected: (newValue) async {
          setState(() {
            selectedModel = newValue;
          });
          // Fetch and set price for the selected model
          if (selectedFrame != null &&
              selectedBrand != null &&
              selectedSize != null &&
              selectedColor != null) {
            var result = await fetchPriceBySelection(selectedFrame!,
                selectedBrand!, selectedSize!, selectedColor!, newValue);
            // Since fetchPriceBySelection now returns a Map, we extract the price string
            String priceString =
                result['price'] ?? "0.0"; // Default to "0.0" if not found
            setState(() {
              selectedPrice = double.tryParse(priceString) ?? 0.0;
            });
          }
        },
      ),
      _buildQuantityField('Quantity'),

      // Price TextField (read-only, displaying calculated price)
      _buildReadOnlyTextField('Total Price', totalPrice.toStringAsFixed(2)),

      // ... add any other fields as needed ...
    ]);
  }

//http://localhost:8001//billing/billings
  Widget _buildInvoiceAndDeliveryDetailsSection() {
    return _buildDetailsCard('Invoice & Delivery Details', [
      _buildDatePickerField(
          'Invoice Date', _formController.invoiceDateController),
      _buildDatePickerField(
          'Delivery Date', _formController.deliveryDateController),
      _buildSalesPersonTextField(), // Updated to use the getter
    ]);
  }

  Widget _buildSalesPersonTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _formController
            .salesPersonController, // Corrected access to use the getter
        decoration: InputDecoration(
          labelText: 'Sales Person',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the salesperson\'s name';
          }
          return null; // Return null if the input is valid
        },
      ),
    );
  }

  Widget _buildLensDetailsSection() {
    return _buildDetailsCard('Lens Details', [
      _buildDropdownField(
        'Lens Category',
        _lensCategories, // Use the fetched categories
        value: _selectedCategory, // Bind the selected value
        onSelected: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
          // Make sure to fetch coatings after setting the new category
          if (newValue != null) {
            _fetchCoatingsForCategory(newValue);
          }
        },
      ),
      _buildDropdownField(
        'Coating',
        _coatings, // Use the dynamically updated coatings list
        value: _selectedCoating, // Bind the selected value
        onSelected: (String? newValue) {
          setState(() {
            _selectedCoating = newValue;
          });
          // Fetch powers after setting the new coating
          if (_selectedCategory != null && newValue != null) {
            _fetchPowersForSelectedCategoryAndCoating(
                _selectedCategory!, newValue);
          }
        },
      ),
      _buildDropdownField(
        'Power',
        _powers, // Assuming this is dynamically updated based on selected coating
        value: _selectedPower,
        onSelected: (String? newValue) {
          setState(() {
            _selectedPower = newValue;
          });
          _calculateAndDisplayTotalPrice();
        },
      ),
      _buildTextField('Quantity', _quantityController),
      _buildReadOnlyTextField(
          'Total Price',
          (_lensPrice * (double.tryParse(_quantityController.text) ?? 1))
              .toStringAsFixed(2)),
    ]);
  }

  void _onCoatingSelected(String? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedCoating = newValue;
      _selectedPower = null; // Reset selected power when coating changes
      _powers = []; // Reset powers list
    });
    if (_selectedCategory != null) {
      _fetchPowersForSelectedCategoryAndCoating(_selectedCategory!, newValue);
    }
  }

// Example call to fetchPowersByCategoryAndCoating with all required arguments
// When you fetch the powers, update the state like this:
  Future<void> _fetchPowersForSelectedCategoryAndCoating(
      String category, String coating) async {
    try {
      // Set loading state to true to show a loading indicator, if you have one
      setState(() {
        isLoadingPowers = true;
      });

      // Call the API to fetch powers
      List<String> powers = await fetchPowersByCategoryAndCoating(
          category, coating, globals.branch_id);
      print("Fetched powers: $powers"); // Add this line to debug
      // Once the data is fetched, update the state with the new powers
      setState(() {
        _powers = powers;
        // Set the first power as selected by default, or handle as needed
        _selectedPower = _powers.isNotEmpty ? _powers.first : null;
        isLoadingPowers =
            false; // Set loading state to false after fetching data
      });
    } catch (e) {
      // If an error occurs, print it to the console or handle it as needed
      print('Error fetching powers: $e');
      // Optionally, update the state to reflect that an error occurred
      setState(() {
        _powers =
            []; // Consider clearing the powers or setting them to a default state
        _selectedPower = null;
        isLoadingPowers =
            false; // Ensure to set loading state to false even on error
      });
    }
  }

// When building the DropdownButtonFormField, make sure to use the updated _powers list
  Widget _buildPowerDropdown() {
    // Handle loading state if necessary
    if (isLoadingPowers) {
      return CircularProgressIndicator(); // Or some other loading indicator
    }

    // Power Dropdown
    return DropdownButtonFormField<String>(
      value: _selectedPower,
      items: _powers.map((power) {
        return DropdownMenuItem<String>(
          value: power,
          child: Text(power),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedPower = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Power',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }

// This method builds the editable table for the prescription details
  ///billing/customers/{customer_id}/prescriptions
  Widget _buildEditableTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('SPH')),
          DataColumn(label: Text('CYL')),
          DataColumn(label: Text('AXIS')),
          DataColumn(label: Text('ADD')),
          // Adding new columns for PD values
          DataColumn(label: Text('PD')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('R')),
            DataCell(_buildEditableCell('R_SPH')),
            DataCell(_buildEditableCell('R_CYL')),
            DataCell(_buildEditableCell('R_AXIS')),
            DataCell(_buildEditableCell('R_ADD')),
            // Adding a new editable cell for right PD
            DataCell(_buildEditableCell('R_PD')),
          ]),
          DataRow(cells: [
            DataCell(Text('L')),
            DataCell(_buildEditableCell('L_SPH')),
            DataCell(_buildEditableCell('L_CYL')),
            DataCell(_buildEditableCell('L_AXIS')),
            DataCell(_buildEditableCell('L_ADD')),
            // Adding a new editable cell for left PD
            DataCell(_buildEditableCell('L_PD')),
          ]),
        ],
      ),
    );
  }

//description table

  Widget _buildItemTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Unit Price')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('Delete')), // Column for delete button
      ],
      rows: List<DataRow>.generate(
        items.length,
        (index) => DataRow(
          cells: [
            DataCell(Text(items[index].description)),
            DataCell(Text(items[index].quantity.toString())),
            DataCell(Text('${items[index].unitPrice}')),
            DataCell(Text('${items[index].totalAmount}')),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(index),
            )),
          ],
        ),
      ),
    );
  }

  void _updateTotalAmount() {
    // Calculate frame total
    double frameTotal = selectedPrice *
        (int.tryParse(_formController.frameQuantityController.text) ?? 1);

    // Assume _lensPrice is already updated either by selection or fetch
    double lensTotal =
        _lensPrice * (double.tryParse(_quantityController.text) ?? 1.0);

    // Calculate total amount
    double totalAmount = frameTotal + lensTotal;

    // Update the Total Amount TextField
    setState(() {
      _formController.totalAmountController.text =
          totalAmount.toStringAsFixed(2);
    });
  }

  Widget _buildPaymentDetailsSection() {
    return _buildDetailsCard('Payment Details', [
      _buildTextField('Total Amount', _formController.totalAmountController),
      _buildTextField('Discount', _formController.discountController),
      _buildTextField(
          'Fitting Charges', _formController.fittingChargesController),
      _buildTextField('Grand Total', _formController.grandTotalController),
      _buildTextField('Advance Paid', _formController.advancePaidController),
      _buildTextField(
          'Balance Amount', _formController.balanceAmountController),
      _buildPayTypeDropdown(),
    ]);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          isDense: true,
        ),
        maxLines: maxLines,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildPayTypeDropdown() {
    String? selectedPayType;
    // Assuming _formController.payTypeController is a TextEditingController
    // You would convert the text controller to a string for the dropdown or manage the state of the dropdown separately
    return DropdownButtonFormField<String>(
      value: selectedPayType,
      decoration: InputDecoration(
        labelText: 'Pay Type',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        isDense: true,
      ),
      items: ['Cash', 'Card'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        // Update the selected pay type state
        selectedPayType = newValue;
        // If you are using a controller for pay type, you can update it here
        // _formController.payTypeController.text = newValue ?? '';
      },
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            // Update the controller's text with the formatted date
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              // Adjusted content padding and isDense
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            ),
            style: TextStyle(fontSize: 14), // Adjusted font size
          ),
        ),
      ),
    );
  }
}
