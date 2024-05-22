import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class AddDirectionView extends StatefulWidget {
  final Function(String id, Map<String, dynamic> directionInFoMap)
      onAddDirection;
  const AddDirectionView({super.key, required this.onAddDirection});

  @override
  State<AddDirectionView> createState() => _AddDirectionViewState();
}

class _AddDirectionViewState extends State<AddDirectionView> {
  final directionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Добавление направления'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/mainScreen');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 15, vertical: screenHeight / 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField('Направление', directionController),
            SizedBox(height: screenHeight / 20),
            SizedBox(
              width: double.maxFinite,
              height: screenHeight / 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: const Color.fromRGBO(103, 80, 165, 1.0),
                ),
                onPressed: _onAddButtonPressed,
                child: Text(
                  'Добавить',
                  style: TextStyle(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontSize: screenHeight / 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _onAddButtonPressed() {
    String id = randomAlphaNumeric(10);
    Map<String, dynamic> directionInfoMap = {
      "ID": id,
      'Direction': directionController.text,
    };
    widget.onAddDirection(id, directionInfoMap);
  }
}
