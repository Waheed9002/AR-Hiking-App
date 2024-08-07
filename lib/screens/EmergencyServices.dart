import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';

class EmergencyServices extends StatefulWidget {
  const EmergencyServices({super.key});

  @override
  _EmergencyServicesState createState() => _EmergencyServicesState();
}

class _EmergencyServicesState extends State<EmergencyServices> {
  List<Map<String, String>> emergencyContacts = [];
  String emergencyNumber = '911'; // Replace with a real emergency number
  final Telephony telephony = Telephony.instance;
  final TextEditingController _sosMessageController = TextEditingController();
  String sosMessage = 'I need help!'; // Default SOS message

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadContacts();
    _loadSosMessage();
  }

  Future<void> _requestPermissions() async {
    await Permission.phone.request();
    await Permission.sms.request();
    await Permission.locationWhenInUse.request();
    await Permission.contacts.request();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('emergencyContacts');
    if (contactsJson != null) {
      setState(() {
        emergencyContacts = List<Map<String, String>>.from(
          json.decode(contactsJson).map((x) => Map<String, String>.from(x)),
        );
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergencyContacts', json.encode(emergencyContacts));
  }

  Future<void> _loadSosMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessage = prefs.getString('sosMessage');
    if (savedMessage != null) {
      setState(() {
        sosMessage = savedMessage;
        _sosMessageController.text = savedMessage;
      });
    }
  }

  Future<void> _saveSosMessage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sosMessage', sosMessage);
  }

  Future<void> _makeCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _sendSMS(List<String> recipients, String message) async {
    for (var recipient in recipients) {
      await telephony.sendSms(
        to: recipient,
        message: message,
      );
    }
  }

  Future<void> _sendSOS() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String message = '$sosMessage\nMy current location is: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    await _sendSMS(emergencyContacts.map((contact) => contact['number']!).toList(), message);
  }

  Future<void> _handleEmergencyCall() async {
    // Display a dialog to choose between predefined number or user contacts
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Emergency Call'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('Call $emergencyNumber'),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await _makeCall(emergencyNumber);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Choose from Contacts'),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await _chooseContactForEmergencyCall();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseContactForEmergencyCall() async {
    PermissionStatus permission = await Permission.contacts.request();
    if (permission.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      Contact? contact = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Contact'),
            content: SizedBox(
              height: 200,
              child: ListView(
                children: contacts.map((contact) {
                  return ListTile(
                    title: Text(contact.displayName ?? 'No Name'),
                    subtitle: Text(contact.phones!.isNotEmpty ? contact.phones!.first.value ?? '' : 'No Phone'),
                    onTap: () => Navigator.pop(context, contact),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );

      if (contact != null && contact.phones!.isNotEmpty) {
        await _makeCall(contact.phones!.first.value!);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission is required')),
      );
    }
  }

  void _editContact(int index) {
    TextEditingController nameController = TextEditingController(text: emergencyContacts[index]['name']);
    TextEditingController numberController = TextEditingController(text: emergencyContacts[index]['number']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                emergencyContacts[index] = {
                  'name': nameController.text,
                  'number': numberController.text,
                };
              });
              _saveContacts();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _removeContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Contact'),
        content: const Text('Are you sure you want to remove this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                emergencyContacts.removeAt(index);
              });
              _saveContacts();
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _addContact() {
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                emergencyContacts.add({
                  'name': nameController.text,
                  'number': numberController.text,
                });
              });
              _saveContacts();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editSosMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit SOS Message'),
        content: TextField(
          controller: _sosMessageController,
          decoration: const InputDecoration(labelText: 'SOS Message'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                sosMessage = _sosMessageController.text;
              });
              _saveSosMessage();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image inside a Card
          Card(
            margin: const EdgeInsets.all(0), // Adjust margin as needed
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, // Top third of the screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/emergency.jpeg'), // Add your image here
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Cylindrical shape
                      ),
                      elevation: 3, // Add some shadow for better look
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          onPressed: _handleEmergencyCall,
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            backgroundColor: Colors.redAccent, // Set a light red color here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Cylindrical shape
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            minimumSize: const Size(200, 60), // Adjust size as needed
                          ),
                          child: const Text('Emergency Call'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Cylindrical shape
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
                            PermissionStatus locationPermission = await Permission.locationWhenInUse.status;

                            if (permissionsGranted == true && locationPermission.isGranted) {
                              await _sendSOS();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Permissions are required to send SOS messages and access location.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Cylindrical shape
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            minimumSize: const Size(200, 60), // Adjust size as needed
                          ),
                          child: const Text('Send SOS SMS'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: const Text('SOS Message'),
                      subtitle: Text(sosMessage),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editSosMessage,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: emergencyContacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(emergencyContacts[index]['name']!),
                            subtitle: Text(emergencyContacts[index]['number']!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editContact(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeContact(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add Contact',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
