import 'package:flutter/material.dart';

List dataList = [
  {
    "name": "Is it possible to modify the personal data file?",
    "name_ar": "தனிப்பட்ட தரவு கோப்பை மாற்ற முடியுமா?",
    "icon": Icons.payment,
    "subMenu": [
      {"name": "Yes, it is possible by entering the profile page in the application.",
        "name_ar": "ஆம், பயன்பாட்டில் சுயவிவரப் பக்கத்தை உள்ளிடுவதன் மூலம் இது சாத்தியமாகும்"},
      // {"name": "Invoices"}
    ]
  },
  {
    "name": "Is the data of the users of the Alaipithal application safe and confidential?",
    "name_ar": "அழைப்பிதழ் செயலியைப் பயன்படுத்துபவர்களின் தரவுகள் பாதுகாப்பானதா மற்றும் ரகசியமானதா?",
    "icon": Icons.payment,
    "subMenu": [
      {"name": "Yes, we in the அழைப்பிதழ் application are committed to protecting and confidentiality of data for users.",
        "name_ar": "ஆம், அழைப்பிதழ் செயலி உள்ள நாங்கள் பயனர்களுக்கான தரவைப் பாதுகாப்பதற்கும் ரகசியத்தன்மைக்கு உறுதியளித்துள்ளோம்."},
      // {"name": "Invoices"}
    ]
  },
  {
    "name": " Does Alaipithal app share user data to a third party?",
    "name_ar": "அழைப்பிதழ் செயலி பயனர் தரவை மூன்றாம் தரப்பினருக்குப் பகிர்கிறதா?",
    "icon": Icons.payment,
    "subMenu": [
      {"name": "Alaipithal application does not share user data with any other party except with the consent of the user.",
        "name_ar": "அழைப்பிதழ் செயலி பயனரின் ஒப்புதலுடன் தவிர வேறு எந்த தரப்பினருடனும் பயனர் தரவைப் பகிராது."},
      // {"name": "Invoices"}
    ]
  },
  {
    "name": "Is it possible to modify the event data after sending the invitations?",
    "name_ar": "அழைப்பிதழை அனுப்பிய பிறகு நிகழ்வின் தரவை மாற்ற முடியுமா?",
    "icon": Icons.payment,
    "subMenu": [
      {"name": " Yes, the event data can be modified after sending the invitation.",
        "name_ar": "ஆம், அழைப்பை அனுப்பிய பிறகு நிகழ்வின் தரவை மாற்றலாம்."},
      // {"name": "Invoices"}
    ]
  },
  {
    "name": "Is it possible to delete the occasion after sending the invitations?",
    "name_ar": "அழைப்பிதழை அனுப்பிய பிறகு நிகழ்வை நீக்க முடியுமா?",
    "icon": Icons.payment,
    "subMenu": [
      {"name": "Yes, the occasion can be deleted",
        "name_ar": "ஆம், நிகழ்வை நீக்கலாம்."},
      // {"name": "Invoices"}
    ]
  },
];

class Menu {
  String? name;
  String? name_ar;
  IconData? icon;
  List<Menu>? subMenu = [];

  Menu({this.name,this.name_ar, this.subMenu, this.icon});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    name_ar = json['name_ar'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu!.clear();
      json['subMenu'].forEach((v) {
        subMenu?.add(new Menu.fromJson(v));
      });
    }
  }
}
