import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uta_library/models/user.dart';
import 'package:uta_library/tools/theme_tools.dart';

class EditNameDialog extends StatefulWidget {
  final User user;
  const EditNameDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Name"),
        backgroundColor:
            ThemeTools.isDarkMode(context) ? Colors.transparent : Colors.white,
        elevation: 0,
        foregroundColor: ThemeTools.appBarForeGroundColor(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: "First name"),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: "Last name"),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.user.uid)
                          .update({
                        "firstName": _firstNameController.text.trim(),
                        "lastName": _lastNameController.text.trim(),
                      }).then((value) => Navigator.pop(context));
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
