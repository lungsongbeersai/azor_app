import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '001');
  TextEditingController passwordController = TextEditingController(text: '002');
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isValidationEnabled = true;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() async {
    // Capture the current scroll position
    double currentScrollPosition = _scrollController.position.pixels;

    await Future.delayed(const Duration(seconds: 2));
    emailController.text = "";
    passwordController.text = "";

    // Restore the scroll position
    _scrollController.jumpTo(currentScrollPosition);
  }

  Future<void> _login() async {
    await Future.delayed(Duration(seconds: 2));
    bool loginblue = false;

    EasyLoading.dismiss();

    if (!loginblue) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: true,
        title: 'ແຈ້ງເຕືອນ',
        desc: 'ຂໍອະໄພ ! ຊື່ ແລະ ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.blue,
        btnOkText: 'ປິດ',
      ).show();
      Navigator.pushReplacementNamed(context, "tap");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double widthscreen = MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            controller: _scrollController, // Attach the ScrollController
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: widthscreen,
                          height: widthscreen,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/images/azor.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      " ອາຊໍ້ ຫູສະຫລາມ",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: 'ອີເມວ',
                              hintStyle: TextStyle(fontSize: 16),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (!_isValidationEnabled) return null;
                              if (value == null || value.isEmpty) {
                                return '* ກະລຸນາປ້ອນອີເມວ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: !_isPasswordVisible,
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              hintText: 'ລະຫັດຜ່ານ',
                              hintStyle: const TextStyle(fontSize: 16),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (!_isValidationEnabled) return null;
                              if (value == null || value.isEmpty) {
                                return '* ກະລຸນາປ້ອນລະຫັດຜ່ານ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isValidationEnabled = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show(status: 'ປະມວນຜົມ...');
                          await _login();
                        }
                        setState(() {
                          _isValidationEnabled = false;
                        });
                      },
                      child: const Text(
                        "ເຂົ້າລະບົບ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
