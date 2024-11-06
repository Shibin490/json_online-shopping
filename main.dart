import 'dart:convert';
import 'dart:io';

// Product class
class Product {
  int id; // ID as an int
  String name;
  double price;
  int quantity;

  Product(this.id, this.name, this.price, this.quantity);

  // Method to print product details
  void printDetails() {

    print("=============================");
    print("product Name: $name");
    print("product Price: $price");
    print("product Quantity: $quantity");
    print("product ID: $id");

  }
}

// DiscountedProduct class8
class DiscountedProduct extends Product {
  double discount;

  DiscountedProduct(
      int id, String name, double price, int quantity, this.discount)
      : super(id, name, price, quantity);

  // Method to get final price after discount
  double getFinalPrice() {
    return price - (price * discount / 100);
  }

  // Override printDetails to include discount information
  @override
  void printDetails() {
  super.printDetails();
  print("Discount: $discount%");
  print("=========================");
  // print("Final Price: \$${getFinalPrice().toStringAsFixed(2)}");
}

}

// ShoppingCart class
class ShoppingCart {
  List<Product> products = [];
  List<DiscountedProduct> discountedProducts = [];

  // Load products from JSON file
  void loadProducts() {
    final file = File('products.json');
    if (file.existsSync()) {
      String contents = file.readAsStringSync();
      List<dynamic> jsonList = json.decode(contents);
      products = jsonList
          .map((json) => Product(
              json['id'], json['name'], json['price'], json['quantity']))
          .toList();
    }
  }

  // Load discounted products from JSON file
  void loadDiscountedProducts() {
    final file = File('discounted_products.json');
    if (file.existsSync()) {
      String contents = file.readAsStringSync();
      List<dynamic> jsonList = json.decode(contents);
      discountedProducts = jsonList
          .map((json) => DiscountedProduct(
                json['id'],
                json['name'],
                json['price'],
                json['quantity'],
                json['discount'],
              ))
          .toList();
    }
  }

  // Save products to JSON file
  void saveProducts() {
    final file = File('products.json');
    String jsonString = json.encode(products
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'price': product.price,
              'quantity': product.quantity,
            })
        .toList());
    file.writeAsStringSync(jsonString);
  }

  // Save discounted products to JSON file
  void saveDiscountedProducts() {
    final file = File('discounted_products.json');
    String jsonString = json.encode(discountedProducts
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'price': product.price,
              'quantity': product.quantity,
              'discount': product.discount,
            })
        .toList());
    file.writeAsStringSync(jsonString);
  }

  // Check if a product ID already exists
  bool idExists(int id) {
    return products.any((product) => product.id == id) ||
        discountedProducts.any((product) => product.id == id);
  }

  // Add product to cart
  void addProduct(Product product) {
    products.add(product);
    saveProducts();
    print('Product added: ${product.name}');
  }

  // Add discounted product to cart
  void addDiscountedProduct(DiscountedProduct product) {
    discountedProducts.add(product);
    saveDiscountedProducts();
    print('Discounted Product added: ${product.name}');
  }

  void updateProduct(int id) {
    try {
      var product = products.firstWhere((p) => p.id == id);

      while (true) {
        print("chose option to update");
        print('1. Name');
        print('2. Price');
        print('3. Quantity');
        print('4. Exit');
        stdout.write('Enter your choice: ');
        String? choice = stdin.readLineSync();

        if (choice == '1') {
          // Update Product Name
          while (true) {
            stdout.write('Enter new Product Name: ');
            String name = stdin.readLineSync()!;
            if (name.isNotEmpty && RegExp(r'^[a-zA-Z]').hasMatch(name)) {
              product.name = name;
              print("Product name updated successfully.");
              break;
            } else {
              print(
                  'Invalid name. The name must start with a letter and cannot be empty.');
            }
          }
        } else if (choice == '2') {
          // Update Product Price
          while (true) {
            stdout.write('Enter new Product Price: ');
            String? input = stdin.readLineSync();
            try {
              double price = double.parse(input!);
              if (price > 0) {
                product.price = price;
                print("Product price updated successfully.");
                break;
              } else {
                print('Price must be a positive number.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid number for the price.');
            }
          }
        } else if (choice == '3') {
          // Update Product Quantity
          while (true) {
            stdout.write('Enter new Product Quantity: ');
            String? input = stdin.readLineSync();
            try {
              int quantity = int.parse(input!);
              if (quantity > 0) {
                product.quantity = quantity;
                print("Product quantity updated successfully.");
                break;
              } else {
                print('Quantity must be a positive number.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid integer for the quantity.');
            }
          }
        } else if (choice == '4') {
          // Exit the update process
          print('Exiting update menu.');
          break;
        } else {
          print('Invalid choice. Please enter a valid option (1-4).');
        }
      }

      saveProducts();
      print('Product details updated: ${product.name}');
    } catch (e) {
      print('Product with ID $id not found.');
    }
  }

  void updateDiscountedProduct(int id) {
    try {
      var discountedProduct =
          discountedProducts.firstWhere((dp) => dp.id == id);

      while (true) {
        print('chose to update');
        print('1. Name');
        print('2. Price');
        print('3. Quantity');
        print('4. Discount Percentage');
        print('5. Exit');
        stdout.write('Enter your choice ');
        String? choice = stdin.readLineSync();

        if (choice == '1') {
          // Update Discounted Product Name
          while (true) {
            stdout.write('Enter new Discounted Product Name: ');
            String name = stdin.readLineSync()!;
            if (name.isNotEmpty && RegExp(r'^[a-zA-Z]').hasMatch(name)) {
              discountedProduct.name = name;
              print("Product name updated successfully.");
              break;
            } else {
              print(
                  'Invalid name. The name must start with a letter and cannot be empty.');
            }
          }
        } else if (choice == '2') {
          // Update Discounted Product Price
          while (true) {
            stdout.write('Enter new Discounted Product Price: ');
            String? input = stdin.readLineSync();
            try {
              double price = double.parse(input!);
              if (price > 0) {
                discountedProduct.price = price;
                print("Product price updated successfully.");
                break;
              } else {
                print('Price must be a positive number.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid number for the price.');
            }
          }
        } else if (choice == '3') {
          // Update Discounted Product Quantity
          while (true) {
            stdout.write('Enter new Discounted Product Quantity: ');
            String? input = stdin.readLineSync();
            try {
              int quantity = int.parse(input!);
              if (quantity > 0) {
                discountedProduct.quantity = quantity;
                print("Product quantity updated successfully.");
                break;
              } else {
                print('Quantity must be a positive number.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid integer for the quantity.');
            }
          }
        } else if (choice == '4') {
          // Update Discount Percentage
          while (true) {
            stdout.write('Enter new Discount Percentage: ');
            String? input = stdin.readLineSync();
            try {
              double discount = double.parse(input!);
              if (discount >= 0 && discount <= 100) {
                discountedProduct.discount = discount;
                print("Discount percentage updated successfully.");
                break;
              } else {
                print('Discount must be between 0 and 100.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid number for the discount percentage.');
            }
          }
        } else if (choice == '5') {
          // Exit the update process
          print('Exiting update menu.');
          break;
        } else {
          print('Invalid choice. Please enter a valid option (1-5).');
        }
      }

      saveDiscountedProducts();
      print('Discounted Product details updated: ${discountedProduct.name}');
    } catch (e) {
      print('Discounted Product with ID $id not found.');
    }
  }
void removeProduct() {
  while (true) {
    stdout.write('Enter Product ID to remove: ');
    String? input = stdin.readLineSync();

    if (input != null && input.isNotEmpty) {
      try {
        int id = int.parse(input);

        // Validate if the ID is a positive number
        if (id <= 0) {
          print('Product ID must be a positive number. Please try again.');
        } 
        // Check if the product exists in the regular products list
        else if (products.any((p) => p.id == id)) {
          products.removeWhere((p) => p.id == id);
          saveProducts(); // Save the updated products list
          print('Product removed.');
          break; // Product removed, exit loop
        } 
        // Check if the product exists in the discounted products list
        else if (discountedProducts.isNotEmpty && discountedProducts.any((dp) => dp.id == id)) {
          discountedProducts.removeWhere((dp) => dp.id == id);
          saveDiscountedProducts(); // Ensure you have a method to save discounted products
          print('Discounted product removed.');
          break; // Discounted product removed, exit loop
        } 
        // If the ID doesn't exist in either list
        else {
          print('Product ID $id not found in either list.');
        }
      } catch (e) {
        print('Invalid input. Please enter a valid number for the Product ID.');
      }
    } else {
      print('Product ID cannot be empty. Please enter a valid Product ID.');
    }
  }
}



  // View cart details
void viewCart() {
  if (products.isEmpty && discountedProducts.isEmpty) {
    print('Your cart is empty.');
    return;
  }

  // Display regular products
  if (products.isNotEmpty) {
    print('Regular Products in Cart:');
    for (var product in products) {
      product.printDetails();
      print(''); // Print an empty line for better readability
    }
  } else {
    print('No regular products in the cart.');
  }

  // Display discounted products
  if (discountedProducts.isNotEmpty) {
    print('Discounted Products in Cart:');
    for (var discountedProduct in discountedProducts) {
      discountedProduct.printDetails();
      print(''); // Print an empty line for better readability
    }
  } else {
    print('No discounted products in the cart.');
  }
}


  // Checkout process
  void checkout() {
    double totalRegular = 0;
    double totalDiscounted = 0;

    // Calculate total for regular products
    for (var product in products) {
      totalRegular += product.price * product.quantity;
    }

    // Calculate total for discounted products
    for (var discountedProduct in discountedProducts) {
      totalDiscounted +=
          discountedProduct.getFinalPrice() * discountedProduct.quantity;
    }

    double finalTotal = totalRegular + totalDiscounted;

    // Display total cost
    print('Total Regular Products: \$$totalRegular');
    print('Total Discounted Products: \$$totalDiscounted');
    print('Total Amount Due: \$$finalTotal');

    // Ask for confirmation
    stdout.write('Do you want to proceed to checkout? (y/n): ');
    String? confirmation = stdin.readLineSync();
    if (confirmation?.toLowerCase() == 'y') {
      print('Thank you for your purchase! Your total is \$$finalTotal.');
      products.clear(); // Clear the cart after successful checkout
      discountedProducts.clear();
      saveProducts(); // Save empty cart
      saveDiscountedProducts(); // Save empty discounted cart
    } else {
      print('Checkout cancelled.');
    }
  }
}

// Main function
void main() {
  final cart = ShoppingCart();

  cart.loadProducts();
  cart.loadDiscountedProducts();

  while (true) {
    print('1. Add Product');
    print('2. Add Discounted Product');
    print('3. Update Product');
    print('4. Update Discounted Product');
    print('5. Remove Product');
    print('6. View Cart');
    print('7. Checkout');
    print('8. Exit');

    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        String name;
        while (true) {
          stdout.write('Enter Product Name: ');
          name = stdin.readLineSync()!;
          if (name.isNotEmpty && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
            break; // Valid name
          } else {
            print(
                'Invalid name. Please enter a valid name (letters only, cannot be empty).');
          }
        }

        double price;

        while (true) {
          stdout.write('Enter Product Price: ');
          String? priceInput = stdin.readLineSync();
          if (priceInput == null || priceInput.isEmpty) {
            print('Price cannot be empty. Please enter a valid price.');
            continue;
          }
          try {
            price = double.parse(priceInput);
            if (price > 0) {
              break; // Valid price
            } else {
              print('Invalid price. Please enter a positive number.');
            }
          } catch (e) {
            print('Invalid input. Please enter a valid number for price.');
          }
        }
        int quantity;

        while (true) {
          stdout.write('Enter Product Quantity: ');
          String? quantityInput = stdin.readLineSync();
          if (quantityInput == null || quantityInput.isEmpty) {
            print('Quantity cannot be empty. Please enter a valid quantity.');
            continue;
          }
          try {
            quantity = int.parse(quantityInput);
            if (quantity >= 0) {
              break; // Valid quantity
            } else {
              print('Invalid quantity. Please enter a non-negative integer.');
            }
          } catch (e) {
            print('Invalid input. Please enter a valid number for quantity.');
          }
        }
        int id;
        while (true) {
          stdout.write('Enter Product ID: ');
          String? input = stdin.readLineSync();

          // Check if the input is not empty and is a valid integer
          if (input != null && input.isNotEmpty) {
            try {
              id = int.parse(input);
              // Check if the ID already exists
              if (cart.idExists(id)) {
                print(
                    'Product ID $id already exists. Please enter a unique ID.');
              } else {
                break; // Valid ID and unique
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid integer for the Product ID.');
            }
          } else {
            print('ID cannot be empty. Please enter a valid Product ID.');
          }
        }

// Once a valid and unique ID is obtained, add the product
        cart.addProduct(Product(id, name, price, quantity));
        break;

      // discount product ====================================================================================

      case '2':
        String name;
        while (true) {
          stdout.write('Enter Product Name: ');
          name = stdin.readLineSync()!;
          if (name.isNotEmpty && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
            break; // Valid name
          } else {
            print(
                'Invalid name. Please enter a valid name (letters only, cannot be empty).');
          }
        }

        double price;

        while (true) {
          stdout.write('Enter Product Price: ');
          String? priceInput = stdin.readLineSync();
          if (priceInput == null || priceInput.isEmpty) {
            print('Price cannot be empty. Please enter a valid price.');
            continue;
          }
          try {
            price = double.parse(priceInput);
            if (price > 0) {
              break; // Valid price
            } else {
              print('Invalid price. Please enter a positive number.');
            }
          } catch (e) {
            print('Invalid input. Please enter a valid number for price.');
          }
        }
        int quantity;

        while (true) {
          stdout.write('Enter Product Quantity: ');
          String? quantityInput = stdin.readLineSync();
          if (quantityInput == null || quantityInput.isEmpty) {
            print('Quantity cannot be empty. Please enter a valid quantity.');
            continue;
          }
          try {
            quantity = int.parse(quantityInput);
            if (quantity >= 0) {
              break; // Valid quantity
            } else {
              print('Invalid quantity. Please enter a non-negative integer.');
            }
          } catch (e) {
            print('Invalid input. Please enter a valid integer for quantity.');
          }
        }
        double discount;
        while (true) {
          stdout.write('Enter Discount Percentage: ');
          String? input = stdin.readLineSync();

          // Check if the input is not empty
          if (input != null && input.isNotEmpty) {
            try {
              discount = double.parse(input);

              // Check if the discount is within the valid range
              if (discount >= 0 && discount <= 100) {
                break; // Valid discount
              } else {
                print('Discount percentage must be between 0 and 100.');
              }
            } catch (e) {
              print(
                  'Invalid input. Please enter a valid number for the discount percentage.');
            }
          } else {
            print(
                'Discount percentage cannot be empty. Please enter a valid percentage.');
          }
        }

        // ======================================================================================================================================

int id;
while (true) {
  stdout.write('Enter Discounted Product ID: ');
  String? input = stdin.readLineSync();

  // Check if the input is null or empty
  if (input == null || input.isEmpty) {
    print('Input cannot be empty. Please enter a valid Product ID.');
  } else {
    try {
      id = int.parse(input);

      // Check if the ID is a positive number
      if (id <= 0) {
        print('Product ID must be a positive number. Please try again.');
      } 
      // Check if the product ID already exists
      else if (cart.idExists(id)) {
        print('Discounted Product ID $id already exists. Please enter a unique ID.');
      } else {
        // If ID is valid and unique, add the discounted product and break the loop
        cart.addDiscountedProduct(
            DiscountedProduct(id, name, price, quantity, discount));
        break; // Valid ID and product added, exit the loop
      }
    } catch (e) {
      print('Invalid input. Please enter a valid number for the Product ID.');
    }
  }
}



case '3':
  while (true) {
    stdout.write('Enter Product ID to update: ');
    String? input = stdin.readLineSync();

    // Check if the input is empty
    if (input == null || input.isEmpty) {
      print('Product ID cannot be empty. Please enter a valid Product ID.');
      continue; // Continue the loop to ask for input again
    }

    try {
      int id = int.parse(input);

      // Validate if the ID is a positive number
      if (id <= 0) {
        print('Product ID must be a positive number. Please try again.');
      } 
      // Check if the product with the given ID exists
      else if (cart.products.any((p) => p.id == id)) {
        cart.updateProduct(id);
        break; // Exit loop after successful update
      } else {
        print('Product ID $id not found.');
        break; // Exit loop if product ID is not found
      }
    } catch (e) {
      print('Invalid input. Please enter a valid number for the Product ID.');
    }
  }
  break;

case '4':
  while (true) {
    stdout.write('Enter Discounted Product ID to update: ');
    String? input = stdin.readLineSync();

    // Check if the input is empty
    if (input == null || input.isEmpty) {
      print('Discounted Product ID cannot be empty. Please enter a valid Discounted Product ID.');
      continue; // Continue the loop to ask for input again
    }

    try {
      int id = int.parse(input);

      // Validate if the ID is a positive number
      if (id <= 0) {
        print('Discounted Product ID must be a positive number. Please try again.');
      } 
      // Check if the discounted product with the given ID exists
      else if (cart.discountedProducts.any((dp) => dp.id == id)) {
        cart.updateDiscountedProduct(id);
        break; // Exit loop after successful update
      } else {
        print('Discounted Product ID $id not found.');
        break; // Exit loop if ID is not found
      }
    } catch (e) {
      print('Invalid input. Please enter a valid number for the Discounted Product ID.');
    }
  }
  break;


      case '5':
        cart.removeProduct();
        break;
      case '6':
        cart.viewCart();
        break;
      case '7':
        cart.checkout();
        break;
      case '8':
        print('Exiting...');
        return;
      default:
        print('Invalid option. Please try again.');
    }
  }
}
