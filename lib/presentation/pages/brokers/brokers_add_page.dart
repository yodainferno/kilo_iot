import 'package:flutter/material.dart';
// import '../widgets/widgets.dart'; // todo

class BrokersAddPage extends StatefulWidget {
  const BrokersAddPage({super.key});

  @override
  BrokersAddPageState createState() => BrokersAddPageState();
}

class BrokersAddPageState extends State<BrokersAddPage> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Brokers'),
        ),
        body: SingleChildScrollView(child: buildBody(context)));
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: 'mqtt.34devs.ru',
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
              onSaved: (value) {
                _address = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(36), // NEW
              ),
              child: const Text('Submit'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('Address: $_address');
                }
              },
            ),
          ],
        )
      )
    );
  }
}
