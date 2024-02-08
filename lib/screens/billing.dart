import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';
 import 'package:optical_desktop/requesthadleing/customer.dart';
import 'package:optical_desktop/controller/FormController.dart';
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
 final TextEditingController _quantityController = TextEditingController(text: "1");
  // String? selectedLensCategory;
  String? _selectedCoating;
  String? _selectedPower;

  bool isLoadingPowers = false;

 
double _quantity = 1; // Default quantity
double _lensPrice = 0.0; // Unit price of the lens

  Map<String, TextEditingController> _controllers = {};
  DateTime _selectedDate = DateTime.now();
  List<Item> items = [
    Item(description: 'Item 1', quantity: 1, unitPrice: 10.0)
  ];
  bool _isSidebarVisible = false;

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
    
  }

  
  @override
  void dispose() {
    // Make sure to dispose of the form controller
    _formController.dispose();
      _quantityController.dispose();
    super.dispose();
  }


void _onQuantityChanged() {
    _calculateAndDisplayTotalPrice();
  }

  void _calculateAndDisplayTotalPrice() {
    if (_selectedCategory != null && _selectedCoating != null && _selectedPower != null && _selectedPower!.isNotEmpty) {
      fetchLensPriceBySelection(
        category: _selectedCategory!,
        coating: _selectedCoating!,
        power: double.tryParse(_selectedPower!) ?? 0.0,
        branchId: globals.branch_id,
      ).then((priceString) {
        setState(() {
          _lensPrice = double.tryParse(priceString) ?? 0.0;
        });
      });
    }
  }

///lensdropdown/onlycategory
 Future<List<String>> fetchLensCategories(int branch_id) async {
    final uri = Uri.parse('http://localhost:8001/lensdropdown/onlycategory?branch_id=$branch_id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = json.decode(response.body);
      return categoriesJson.cast<String>();
    } else {
      print('Error fetching categories: ${response.statusCode}');
      return [];
    }
  }

  Future<List<String>> fetchCoatingsByCategory(String category, int branchId) async {
  final uri = Uri.parse('http://localhost:8001/lensdropdown/coatings-by-category?category=$category&branch_id=$branchId');
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
  List<String> fetchedCoatings = await fetchCoatingsByCategory(category, globals.branch_id);
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
          _coatings.clear(); // Optionally clear coatings when category changes
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
Future<List<String>> fetchPowersByCategoryAndCoating(String category, String coating, int branchId) async {
  final uri = Uri.parse('http://localhost:8001/lensdropdown/powers-by-category-and-coating')
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
      List<String> powers = powersJson.map((dynamic value) => value.toString()).toList();
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

Future<String> fetchLensPriceBySelection({
  required String category,
  required String coating,
  required double power,
  required int branchId,
}) async {
  final uri = Uri.parse('http://localhost:8001/lensdropdown/lens-price-by-selection')
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
      return jsonResponse['price'].toString(); // Assuming 'price' is a key in the response JSON
    } else {
      print('Error fetching price: ${response.statusCode}');
      return "Error fetching price";
    }
  } catch (e) {
    print('Exception when fetching price: $e');
    return "Error fetching price";
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

  Future<String> fetchPriceBySelection(String frame, String brand, String size,
      String color, String model) async {
    // Construct the URL with the branch_id query parameter
    final queryParameters = {
      'frame': frame,
      'brand': brand,
      'size': size,
      'color': color,
      'model': model,
      'branch_id': globals.branch_id
          .toString(), // Converting int to String to be used in URL
    };
    final uri = Uri.http(
        'localhost:8001', '/dropdown/price-by-selection', queryParameters);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String priceString = jsonResponse['price'].toString();
      print("Price received: $priceString"); // Print the received price
      return priceString;
    } else {
      // Handle the error; maybe show a message to the user
      print("Error fetching price: ${response.body}");
      return "Error fetching price";
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
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
           _submitCustomerForm(); 
        },
        child: Icon(Icons.print),
        tooltip: 'Save & Print (F12)',
      ),
    );
  }

  void _submitCustomerForm() async {
  // Collecting the form data from the text editing controllers
  String mobileNumber = _formController.mobileNumberController.text.trim();
  String fullName = _formController.fullNameController.text.trim();
  String nicNumber = _formController.nicNumberController.text.trim();
  String address = _formController.addressController.text.trim();
  String gender = _selectedGender ?? 'Not Specified'; // Assuming _selectedGender is managed outside the FormController

  // Assuming you have a method to validate your form fields
  bool isValid = _validateForm(mobileNumber, fullName, nicNumber, address, gender);
  if (!isValid) {
    // Handle invalid form data (e.g., show error messages)
    print('Form validation failed.');
    return;
  }

  // If the form is valid, proceed with the submission
  try {
    // Assuming CustomerPostService is your backend service class
    bool success = await CustomerPostService.postCustomerDetails(
      mobileNumber: mobileNumber,
      fullName: fullName,
      nicNumber: nicNumber,
      address: address,
      gender: gender,
    
    );

    if (success) {
      // Handle the successful submission (e.g., showing a success dialog or navigating to another page)
      print('Customer details submitted successfully.');
    } else {
      // Handle submission failure (e.g., showing an error dialog)
      print('Failed to submit customer details.');
    }
  } catch (e) {
    // Handle any errors that occur during submission
    print('An error occurred while submitting the form: $e');
  }
}

bool _validateForm(String mobileNumber, String fullName, String nicNumber, String address, String gender) {
  // Define a mobile number pattern (e.g., Sri Lankan mobile numbers)
  final mobileNumberPattern = RegExp(r'^07[01245678][0-9]{7}$');
  
  // Define a NIC number pattern (e.g., old NIC number format in Sri Lanka)
  final nicNumberPattern = RegExp(r'^[0-9]{9}[vVxX]$');

  // Check if any of the fields are empty
  if (mobileNumber.isEmpty || fullName.isEmpty || nicNumber.isEmpty || address.isEmpty || gender.isEmpty) {
    return false;
  }

  // Validate the mobile number against the pattern
  if (!mobileNumberPattern.hasMatch(mobileNumber)) {
    return false;
  }

  // Validate the NIC number against the pattern
  if (!nicNumberPattern.hasMatch(nicNumber)) {
    return false;
  }

  // If all checks pass, return true
  return true;
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
    // Create a controller if it doesn't exist
    _controllers.putIfAbsent(key, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsSection() {
    return _buildDetailsCard('Customer Details', [
_buildTextField('Mobile Number', _formController.mobileNumberController),
_buildTextField('Full Name', _formController.fullNameController),
_buildTextField('NIC Number', _formController.nicNumberController),
_buildTextField('Address', _formController.addressController, maxLines: 3),

      _buildGenderDropdown()
      // _buildDropdownField('Gender', ['Male', 'Female', 'Other'], onSelected: (String ) {  }),
    ]);
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

  Widget _buildQuantityField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextField(
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
              // Handle error for invalid input (e.g., non-numeric input)
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
            String priceString = await fetchPriceBySelection(selectedFrame!,
                selectedBrand!, selectedSize!, selectedColor!, newValue);
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

  Widget _buildInvoiceAndDeliveryDetailsSection() {
    return _buildDetailsCard('Invoice & Delivery Details', [
      _buildDatePickerField('Invoice Date'),
      _buildDatePickerField('Delivery Date'),
      _buildDropdownField('Sales Person', ['Person1', 'Person2'],
          onSelected: (String) {}),
    ]);
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
          _fetchPowersForSelectedCategoryAndCoating(_selectedCategory!, newValue);
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
     _buildReadOnlyTextField('Total Price', (_lensPrice * (double.tryParse(_quantityController.text) ?? 1)).toStringAsFixed(2)),
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
Future<void> _fetchPowersForSelectedCategoryAndCoating(String category, String coating) async {
  try {
    // Set loading state to true to show a loading indicator, if you have one
    setState(() {
      isLoadingPowers = true;
    });

    // Call the API to fetch powers
    List<String> powers = await fetchPowersByCategoryAndCoating(category, coating, globals.branch_id);
print("Fetched powers: $powers"); // Add this line to debug
    // Once the data is fetched, update the state with the new powers
    setState(() {
      _powers = powers;
      // Set the first power as selected by default, or handle as needed
      _selectedPower = _powers.isNotEmpty ? _powers.first : null;
      isLoadingPowers = false; // Set loading state to false after fetching data
    });
  } catch (e) {
    // If an error occurs, print it to the console or handle it as needed
    print('Error fetching powers: $e');
    // Optionally, update the state to reflect that an error occurred
    setState(() {
      _powers = []; // Consider clearing the powers or setting them to a default state
      _selectedPower = null;
      isLoadingPowers = false; // Ensure to set loading state to false even on error
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
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('R')),
            DataCell(_buildEditableCell('R_SPH')),
            DataCell(_buildEditableCell('R_CYL')),
            DataCell(_buildEditableCell('R_AXIS')),
            DataCell(_buildEditableCell('R_ADD')),
          ]),
          DataRow(cells: [
            DataCell(Text('L')),
            DataCell(_buildEditableCell('L_SPH')),
            DataCell(_buildEditableCell('L_CYL')),
            DataCell(_buildEditableCell('L_AXIS')),
            DataCell(_buildEditableCell('L_ADD')),
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

Widget _buildPaymentDetailsSection() {
  return _buildDetailsCard('Payment Details', [
    _buildTextField('Total Amount', _formController.totalAmountController),
    _buildTextField('Discount', _formController.discountController),
    _buildTextField('Fitting Charges', _formController.fittingChargesController),
    _buildTextField('Grand Total', _formController.grandTotalController),
    _buildTextField('Advance Paid', _formController.advancePaidController),
    _buildTextField('Balance Amount', _formController.balanceAmountController),
    _buildPayTypeDropdown(),
  ]);
}

Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
  

  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 10.0), // Smaller padding
              isDense: true, // Added to reduce the height
            ),
            controller: TextEditingController(
                text: _selectedDate.toLocal().toString().split(' ')[0]),
            style: TextStyle(fontSize: 12), // Smaller font size
          ),
        ),
      ),
    );
  }
}
