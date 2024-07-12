import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _quantity = 1;
  String _selectedSize = '';

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ລາຍລະອຽດ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 260,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/beer.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          "ເບຍລາວແກ້ວ ແກ້ວໃຫຍ່",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "ຕົວເລືອກ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildSizeOption('ນ້ອຍ', 30000),
                          _buildSizeOption('ກາງ', 40000),
                          _buildSizeOption('ໃຫຍ່', 50000),
                          _buildSizeOption('ໃຫຍ່ສຸດ', 60000),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decrementQuantity,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _quantity.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _incrementQuantity,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ເພີ່ມໃສ່ກະຕ໋າ ສໍາເລັດແລ້ວ'),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'ເພີ່ມໃສ່ກະຕ໋າ',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size, int price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          size,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          '${price}',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        leading: Transform.scale(
          scale: 1.8,
          child: Radio<String>(
            value: size,
            groupValue: _selectedSize,
            onChanged: (String? newSize) {
              setState(() {
                _selectedSize = newSize!;
              });
            },
          ),
        ),
        selected: _selectedSize == size,
        selectedTileColor: Colors.blue,
        onTap: () {
          setState(() {
            _selectedSize = size;
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      ),
    );
  }

  String _calculatePrice() {
    switch (_selectedSize) {
      case 'S':
        return '\$3000';
      case 'M':
        return '\$4000';
      case 'L':
        return '\$5000';
      case 'XL':
        return '\$6000';
      default:
        return '\$4000';
    }
  }
}
