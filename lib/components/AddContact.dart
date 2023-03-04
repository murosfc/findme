import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../model/Contact.dart';
import '../pages/LoginPage.dart';

class AddContactDialog extends StatefulWidget {
  final Function(Contact) onAddContact;

  const AddContactDialog({Key? key, required this.onAddContact})
      : super(key: key);
  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  Contact _newContact = Contact(0, '', '', '');

  bool _isLoading = false;
  String _errorMessage = '';

  void _handleAddContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        _newContact = await Contact.addContact(_email);
        widget.onAddContact(_newContact);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, _newContact);
      } catch (error) {
        if (error.toString() == "Invalid credentials") {
          setState(() {
            _errorMessage = error.toString().replaceAll('Exception:', '');
            _isLoading = false;
          });
          await Future.delayed(const Duration(seconds: 2));
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          setState(() {
            _errorMessage = error.toString().replaceAll('Exception:', '');
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("add-contact".i18n()),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                hintText: 'email'.i18n(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter-email'.i18n();
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'cancel'.i18n(),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleAddContact,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
