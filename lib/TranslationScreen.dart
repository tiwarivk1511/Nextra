import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String originalLanguage = '';
  String destinationLanguage = '';
  String inputText = '';
  String translatedText = '';
  TextEditingController textEditingController = TextEditingController();

  FlutterTts flutterTts = FlutterTts();
  List<Map<String, String>> languages = [
    // Your language list here
    {'code': 'Select Language', 'name': 'Select Language'},
    {'code': 'af', 'name': 'Afrikaans'},
    {'code': 'sq', 'name': 'Albanian'},
    {'code': 'am', 'name': 'Amharic'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'hy', 'name': 'Armenian'},
    {'code': 'as', 'name': 'Assamese'},
    {'code': 'ay', 'name': 'Aymara'},
    {'code': 'az', 'name': 'Azerbaijani'},
    {'code': 'bm', 'name': 'Bambara'},
    {'code': 'eu', 'name': 'Basque'},
    {'code': 'be', 'name': 'Belarusian'},
    {'code': 'bn', 'name': 'Bengali'},
// {'code': 'bh', 'name': 'Bhojpuri'}, // Unwritable
    {'code': 'bs', 'name': 'Bosnian'},
    {'code': 'bg', 'name': 'Bulgarian'},
    {'code': 'ca', 'name': 'Catalan'},
    {'code': 'ceb', 'name': 'Cebuano'},
    {'code': 'ny', 'name': 'Chichewa'},
    {'code': 'zh-CN', 'name': 'Chinese (Simplified)'},
    {'code': 'zh-TW', 'name': 'Chinese (Traditional)'},
    {'code': 'co', 'name': 'Corsican'},
    {'code': 'hr', 'name': 'Croatian'},
    {'code': 'cs', 'name': 'Czech'},
    {'code': 'da', 'name': 'Danish'},
    {'code': 'dv', 'name': 'Dhivehi'},
// {'code': 'doi', 'name': 'Dogri'}, // Unwritable
    {'code': 'nl', 'name': 'Dutch'},
    {'code': 'en', 'name': 'English'},
    {'code': 'eo', 'name': 'Esperanto'},
    {'code': 'et', 'name': 'Estonian'},
    {'code': 'ee', 'name': 'Ewe'},
    {'code': 'tl', 'name': 'Filipino'},
    {'code': 'fi', 'name': 'Finnish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'fy', 'name': 'Frisian'},
    {'code': 'gl', 'name': 'Galician'},
    {'code': 'ka', 'name': 'Georgian'},
    {'code': 'de', 'name': 'German'},
    {'code': 'el', 'name': 'Greek'},
    {'code': 'gn', 'name': 'Guarani'},
    {'code': 'gu', 'name': 'Gujarati'},
    {'code': 'ht', 'name': 'Haitian Creole'},
    {'code': 'ha', 'name': 'Hausa'},
    {'code': 'haw', 'name': 'Hawaiian'},
    {'code': 'he', 'name': 'Hebrew'},
    {'code': 'hi', 'name': 'Hindi'},
// {'code': 'hmn', 'name': 'Hmong'}, // Unwritable
    {'code': 'hu', 'name': 'Hungarian'},
    {'code': 'is', 'name': 'Icelandic'},
    {'code': 'ig', 'name': 'Igbo'},
// {'code': 'ilo', 'name': 'Ilocano'}, // Unwritable
    {'code': 'id', 'name': 'Indonesian'},
    {'code': 'ga', 'name': 'Irish'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'jv', 'name': 'Javanese'},
    {'code': 'kn', 'name': 'Kannada'},
    {'code': 'kk', 'name': 'Kazakh'},
    {'code': 'km', 'name': 'Khmer'},
    {'code': 'rw', 'name': 'Kinyarwanda'},
// {'code': 'kok', 'name': 'Konkani'}, // Unwritable
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'kri', 'name': 'Krio'},
    {'code': 'ku', 'name': 'Kurdish (Kurmanji)'},
    {'code': 'ckb', 'name': 'Kurdish (Sorani)'},
    {'code': 'ky', 'name': 'Kyrgyz'},
    {'code': 'lo', 'name': 'Lao'},
    {'code': 'la', 'name': 'Latin'},
    {'code': 'lv', 'name': 'Latvian'},
    {'code': 'ln', 'name': 'Lingala'},
    {'code': 'lt', 'name': 'Lithuanian'},
    {'code': 'lg', 'name': 'Luganda'},
    {'code': 'lb', 'name': 'Luxembourgish'},
    {'code': 'mk', 'name': 'Macedonian'},
    {'code': 'mai', 'name': 'Maithili'},
    {'code': 'mg', 'name': 'Malagasy'},
    {'code': 'ms', 'name': 'Malay'},
    {'code': 'ml', 'name': 'Malayalam'},
    {'code': 'mt', 'name': 'Maltese'},
    {'code': 'mi', 'name': 'Maori'},
    {'code': 'mr', 'name': 'Marathi'},
// {'code': 'mni', 'name': 'Meiteilon (Manipuri)'}, // Unwritable
    {'code': 'lus', 'name': 'Mizo'},
    {'code': 'mn', 'name': 'Mongolian'},
    {'code': 'my', 'name': 'Myanmar (Burmese)'},
    {'code': 'ne', 'name': 'Nepali'},
    {'code': 'no', 'name': 'Norwegian'},
    {'code': 'or', 'name': 'Odia (Oriya)'},
    {'code': 'om', 'name': 'Oromo'},
    {'code': 'ps', 'name': 'Pashto'},
    {'code': 'fa', 'name': 'Persian'},
    {'code': 'pl', 'name': 'Polish'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'pa', 'name': 'Punjabi'},
    {'code': 'qu', 'name': 'Quechua'},
    {'code': 'ro', 'name': 'Romanian'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'sm', 'name': 'Samoan'},
    {'code': 'sa', 'name': 'Sanskrit'},
    {'code': 'gd', 'name': 'Scots Gaelic'},
    {'code': 'nso', 'name': 'Sepedi'},
    {'code': 'sr', 'name': 'Serbian'},
    {'code': 'st', 'name': 'Sesotho'},
    {'code': 'sn', 'name': 'Shona'},
    {'code': 'sd', 'name': 'Sindhi'},
    {'code': 'si', 'name': 'Sinhala'},
    {'code': 'sk', 'name': 'Slovak'},
    {'code': 'sl', 'name': 'Slovenian'},
    {'code': 'so', 'name': 'Somali'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'su', 'name': 'Sundanese'},
    {'code': 'sw', 'name': 'Swahili'},
    {'code': 'sv', 'name': 'Swedish'},
    {'code': 'tg', 'name': 'Tajik'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'tt', 'name': 'Tatar'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'ti', 'name': 'Tigrinya'},
    {'code': 'ts', 'name': 'Tsonga'},
    {'code': 'tr', 'name': 'Turkish'},
    {'code': 'tk', 'name': 'Turkmen'},
    {'code': 'tw', 'name': 'Twi'},
    {'code': 'uk', 'name': 'Ukrainian'},
    {'code': 'ur', 'name': 'Urdu'},
    {'code': 'ug', 'name': 'Uyghur'},
    {'code': 'uz', 'name': 'Uzbek'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'cy', 'name': 'Welsh'},
    {'code': 'xh', 'name': 'Xhosa'},
    {'code': 'yi', 'name': 'Yiddish'},
    {'code': 'yo', 'name': 'Yoruba'},
    {'code': 'zu', 'name': 'Zulu'},
// Add all other languages here
  ];

  @override
  void initState() {
    super.initState();
    if (languages.isNotEmpty) {
      originalLanguage = languages[0]['name']!;
      destinationLanguage = languages[0]['name']!;
    }
    initializeTts();
  }

  String getLanguageCode(String languageName) {
    for (var language in languages) {
      if (language['name'] == languageName) {
        return language['code']!;
      }
    }
    return '';
  }

  Future<void> initializeTts() async {
    await flutterTts.setLanguage(destinationLanguage);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(4.0);
  }

  Future<void> speakTranslatedText() async {
    if (translatedText.isEmpty) {
      await flutterTts.setLanguage(destinationLanguage);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(4.0);
      await flutterTts.speak('Please translate the text first');
    } else {
      await flutterTts.setLanguage(destinationLanguage);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(4.0);
      await flutterTts.speak(translatedText);
    }
  }

  Future<void> translateText(String originalLanguage,
      String destinationLanguage, String inputText) async {
    if (originalLanguage.isEmpty) {
      setState(() {
        translatedText = "Please select the original language";
      });
      return;
    }
    GoogleTranslator translator = GoogleTranslator();
    var translated = await translator.translate(inputText,
        from: originalLanguage, to: destinationLanguage);
    setState(() {
      translatedText = translated.toString();
    });
  }

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translated text copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: const Text(
          'Translation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg', // Replace 'background.svg' with the path to your SVG file
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            color: const Color.fromARGB(1, 32, 29, 43).withOpacity(0.9),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Translate From Card
                  Card(
                    elevation: 4,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Translate From',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Original Language Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  hintText: 'Select Language',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                                value: originalLanguage,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      originalLanguage = newValue;
                                    });
                                    translateText(
                                      getLanguageCode(originalLanguage),
                                      getLanguageCode(destinationLanguage),
                                      inputText,
                                    );
                                  }
                                },
                                items: languages
                                    .map<DropdownMenuItem<String>>((language) {
                                  return DropdownMenuItem<String>(
                                    value: language['name']!,
                                    child: Text(
                                      language['name']!,
                                      style: const TextStyle(
                                          color: Colors.blueGrey),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              // Destination Language Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  hintText: 'Select Language',
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                                value: destinationLanguage,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      destinationLanguage = newValue;
                                    });
                                    translateText(
                                      getLanguageCode(originalLanguage),
                                      getLanguageCode(destinationLanguage),
                                      inputText,
                                    );
                                  }
                                },
                                items: languages
                                    .map<DropdownMenuItem<String>>((language) {
                                  return DropdownMenuItem<String>(
                                    value: language['name']!,
                                    child: Text(
                                      language['name']!,
                                      style: const TextStyle(
                                          color: Colors.blueGrey),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Text Input Field
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        inputText = value;
                      });
                    },
                    maxLines: 5,
                    minLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Enter text to translate',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    controller: textEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text to Translate';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Translate and Copy Buttons
                  Card(
                    color: const Color.fromRGBO(55, 38, 63, 1).withOpacity(0.1),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Translate Button
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await translateText(
                                    getLanguageCode(originalLanguage),
                                    getLanguageCode(destinationLanguage),
                                    textEditingController.text.toString(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.translate,
                                ),
                                label: const Text(
                                  'Translate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.purple.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              // Copy Button
                              ElevatedButton.icon(
                                autofocus: true,
                                onPressed: copyToClipboard,
                                icon: const Icon(Icons.copy),
                                label: const Text(
                                  'Copy to Clipboard',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.purple.shade300,
                                  padding: const EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Translated Text
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Card(
                      elevation: 4,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Translated Text:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  translatedText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),

                                // Speak Button
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: speakTranslatedText,
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text(
                                    'Speak',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.purple.shade300,
                                    padding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
