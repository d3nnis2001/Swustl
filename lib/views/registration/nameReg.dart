import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swustl/views/registration/educationReg.dart';
import 'package:swustl/models/user_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegistrationPage1 extends StatefulWidget {
  final UserData userData;
  
  const RegistrationPage1({
    super.key, 
    required this.userData,
  });

  @override
  State<RegistrationPage1> createState() => _RegistrationPage1State();
}

class _RegistrationPage1State extends State<RegistrationPage1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String _selectedCountry = 'Deutschland';
  final List<String> _countries = [
    'Deutschland', 'Österreich', 'Schweiz', 'Frankreich', 
    'Italien', 'Spanien', 'Niederlande', 'Belgien',
    'Großbritannien', 'USA', 'Kanada', 'Australien',
  ];

  // Für die Bildauswahl
  File? _imageFile;
  String? _selectedAvatar;
  final List<String> _avatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
  ];

  @override
  void initState() {
    super.initState();
    // Vorausfüllen der Felder, falls bereits Daten vorhanden sind
    _firstNameController.text = widget.userData.firstName;
    _lastNameController.text = widget.userData.lastName;
    _usernameController.text = widget.userData.username;
    
    if (widget.userData.birthDay != 0) {
      _dayController.text = widget.userData.birthDay.toString();
    }
    if (widget.userData.birthMonth != 0) {
      _monthController.text = widget.userData.birthMonth.toString();
    }
    if (widget.userData.birthYear != 0) {
      _yearController.text = widget.userData.birthYear.toString();
    }
    
    _phoneController.text = widget.userData.phoneNumber;
    
    if (widget.userData.country.isNotEmpty) {
      _selectedCountry = widget.userData.country;
    }
    
    // Falls bereits ein Avatar ausgewählt wurde
    _selectedAvatar = widget.userData.avatarPath;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      // Daten speichern
      widget.userData.firstName = _firstNameController.text;
      widget.userData.lastName = _lastNameController.text;
      widget.userData.username = _usernameController.text;
      widget.userData.birthDay = int.tryParse(_dayController.text) ?? 0;
      widget.userData.birthMonth = int.tryParse(_monthController.text) ?? 0;
      widget.userData.birthYear = int.tryParse(_yearController.text) ?? 0;
      widget.userData.country = _selectedCountry;
      widget.userData.phoneNumber = _phoneController.text;
      
      // Bildpfad speichern
      if (_imageFile != null) {
        widget.userData.profileImagePath = _imageFile!.path;
        widget.userData.avatarPath = null;
      } else if (_selectedAvatar != null) {
        widget.userData.avatarPath = _selectedAvatar;
        widget.userData.profileImagePath = null;
      }
      
      return true;
    }
    return false;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _selectedAvatar = null; // Avatar-Auswahl zurücksetzen, wenn ein Bild gewählt wurde
      });
    }
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wähle einen Avatar'),
          content: Container(
            width: double.maxFinite,
            height: 250,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                final avatarPath = _avatars[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatarPath;
                      _imageFile = null; // Bildauswahl zurücksetzen
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedAvatar == avatarPath ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persönliche Informationen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profilbild
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : _selectedAvatar != null
                                        ? Image.asset(
                                            _selectedAvatar!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.person, size: 60, color: Colors.grey),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                                  onPressed: _pickImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _showAvatarSelectionDialog,
                          icon: const Icon(Icons.face, size: 18),
                          label: const Text('Avatar wählen'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            textStyle: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Vorname *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gib deinen Vornamen ein';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Nachname
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Nachname *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gib deinen Nachnamen ein';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Benutzername *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixText: '@',
                      prefixIcon: const Icon(Icons.alternate_email),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gib einen Benutzernamen ein';
                      }
                      if (value.contains(' ')) {
                        return 'Der Benutzername darf keine Leerzeichen enthalten';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Geburtstag
                  Row(
                    children: [
                      const Icon(Icons.cake_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        'Geburtsdatum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      // Tag
                      Expanded(
                        child: TextFormField(
                          controller: _dayController,
                          decoration: InputDecoration(
                            labelText: 'TT',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              int? day = int.tryParse(value);
                              if (day == null || day < 1 || day > 31) {
                                return 'Ungültig';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Monat
                      Expanded(
                        child: TextFormField(
                          controller: _monthController,
                          decoration: InputDecoration(
                            labelText: 'MM',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              int? month = int.tryParse(value);
                              if (month == null || month < 1 || month > 12) {
                                return 'Ungültig';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Jahr
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: 'JJJJ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              int? year = int.tryParse(value);
                              if (year == null || year < 1900 || year > DateTime.now().year) {
                                return 'Ungültiges Jahr';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Land
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Land *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.public),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    value: _selectedCountry,
                    items: _countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCountry = newValue;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte wähle ein Land aus';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Telefonnummer
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefonnummer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '+49 123 456789',
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 16),
            
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Zurück zum Login
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Zurück'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage2(userData: widget.userData),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Weiter'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}