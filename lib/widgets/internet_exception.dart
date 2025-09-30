import 'package:flutter/material.dart';

class InternetExceptionWidget extends StatelessWidget {
  final VoidCallback onpress;
  const InternetExceptionWidget({super.key, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.15,
        ),
        const Icon(
          Icons.cloud_off,
          color: Colors.red,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
            child: Text("Please check your internet connection",
                style: Theme.of(context).textTheme.displayLarge),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 100,
          child: ElevatedButton(
              
              onPressed: onpress,
              child: Text(
                "RETRY",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 12, color: Colors.red),
              )),
        )
      ],
    );
  }
}
