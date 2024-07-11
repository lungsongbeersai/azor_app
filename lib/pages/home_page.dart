import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 840) {
      _crossAxisCount = 3; // For tablets
    }
    if (MediaQuery.of(context).size.width >= 840 &&
        MediaQuery.of(context).size.width < 1200) {
      _crossAxisCount = 4; // For larger tablets
    }
    if (MediaQuery.of(context).size.width >= 1200) {
      _crossAxisCount = 5; // For larger screens (Android tablets, desktops)
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "ລາຍການໂຕະ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: 6,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = index;
                  String text;
                  if (item == 0) {
                    text = " ທັງໝົດ ";
                  } else if (item == 1) {
                    text = " ໂຊນນອກ ";
                  } else if (item == 2) {
                    text = " ໂຊນໃນ ";
                  } else if (item == 3) {
                    text = " ໂຊນຕູບ ";
                  } else if (item == 4) {
                    text = " ຊັ້ນເທິງ ";
                  } else {
                    text = " ຊັ້ນລຸ່ມ ";
                  }

                  return GestureDetector(
                    onTap: () {
                      print("1");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item != 0
                            ? const Color(0xFFF0F0F0)
                            : const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: item != 0
                              ? const Color(0xFF606060)
                              : Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {});
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "table_id",
                          arguments: '$index',
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: index == 3
                              ? Color.fromARGB(255, 246, 248, 230)
                              : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'T$index',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
