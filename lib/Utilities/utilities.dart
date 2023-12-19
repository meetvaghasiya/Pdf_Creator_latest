import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(100, 105, 105, 105),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: FittedBox(
              fit: BoxFit.none,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: CircularProgressIndicator(),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 100,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            color: Color.fromARGB(100, 105, 105, 105)),
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircularProgressIndicator(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }
}