import 'package:azor/services/provider_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _crossAxisCount = 3;
  @override
  void initState() {
    super.initState();
    final providerService =
        Provider.of<ProviderService>(context, listen: false);
    providerService.getZone();
  }

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

    final providerService = Provider.of<ProviderService>(context);
    final zoneList = providerService.zoneList;
    final tableList=

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
                itemCount: zoneList.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        print("All selected");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: providerService.selectedIndex != index
                              ? const Color(0xFFEBEAEA)
                              : const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'ທັງໝົດ',
                          style: TextStyle(
                            color: providerService.selectedIndex != index
                                ? const Color(0xFF606060)
                                : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final zone = zoneList[index - 1];
                    return GestureDetector(
                      onTap: () {
                        print("result:${zone.zoneCode}");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: providerService.selectedIndex != index
                              ? const Color(0xFFEBEAEA)
                              : const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          zone.zoneName.toString(),
                          style: TextStyle(
                            color: providerService.selectedIndex != index
                                ? const Color(0xFF606060)
                                : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    providerService.getPullRefresh();
                  });
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
