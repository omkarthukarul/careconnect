import 'app_language.dart';

class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _localizedValues = {
    // App & Header
    'appName': {
      'en': 'CareConnect Maharashtra',
      'mr': 'संजीवन महा-नेट',
    },
    'appSubName': {
      'en': 'Sanjeevan Maha-Net',
      'mr': 'केअरकनेक्ट महाराष्ट्र',
    },
    'tagline': {
      'en': 'From first contact to completed care.',
      'mr': 'पहिल्या संपर्कापासून पूर्ण उपचारापर्यंत.',
    },
    'govSubtitle': {
      'en': 'Government of Maharashtra Public Health Department',
      'mr': 'सार्वजनिक आरोग्य विभाग, महाराष्ट्र शासन',
    },
    'sihBadge': {
      'en': 'Smart India Hackathon HealthTech',
      'mr': 'स्मार्ट इंडिया हॅकाथॉन हेल्थटेक',
    },

    // Navigation & Roles
    'dashboard': {
      'en': 'Dashboard',
      'mr': 'डॅशबोर्ड',
    },
    'patients': {
      'en': 'Patients',
      'mr': 'रुग्ण',
    },
    'triage': {
      'en': 'Triage',
      'mr': 'प्राथमिक तपासणी',
    },
    'referrals': {
      'en': 'Referrals',
      'mr': 'संदर्भ',
    },
    'profile': {
      'en': 'Profile',
      'mr': 'प्रोफाइल',
    },
    'medicalOfficer': {
      'en': 'Medical Officer',
      'mr': 'वैद्यकीय अधिकारी',
    },
    'hospitalStaff': {
      'en': 'Hospital Staff',
      'mr': 'रुग्णालय कर्मचारी',
    },
    'ambulanceEMS': {
      'en': 'Ambulance / EMS',
      'mr': 'रुग्णवाहिका / आपत्कालीन',
    },
    'patientRole': {
      'en': 'Patient',
      'mr': 'रुग्ण / नागरिक',
    },

    // Auth
    'login': {
      'en': 'LOGIN',
      'mr': 'लॉगिन करा',
    },
    'demoLogin': {
      'en': 'DEMO LOGIN',
      'mr': 'डेमो लॉगिन',
    },
    'mobileOrEmail': {
      'en': 'Mobile Number / Email',
      'mr': 'मोबाईल क्रमांक / ईमेल',
    },
    'password': {
      'en': 'Password',
      'mr': 'पासवर्ड',
    },
    'selectRole': {
      'en': 'Select Your Role',
      'mr': 'तुमची भूमिका निवडा',
    },
    'logout': {
      'en': 'Logout',
      'mr': 'लॉगआउट',
    },

    // Medical Officer Dashboard Metrics
    'activePatients': {
      'en': 'Active Patients',
      'mr': 'सक्रिय रुग्ण',
    },
    'pendingReferrals': {
      'en': 'Pending Referrals',
      'mr': 'प्रलंबित संदर्भ',
    },
    'emergencyCases': {
      'en': 'Emergency Cases',
      'mr': 'तातडीची प्रकरणे',
    },
    'availableFacilities': {
      'en': 'Available Facilities',
      'mr': 'उपलब्ध रुग्णालये',
    },

    // Quick Actions
    'quickActions': {
      'en': 'Quick Actions',
      'mr': 'जलद कृती',
    },
    'registerPatient': {
      'en': 'Register Patient',
      'mr': 'रुग्ण नोंदणी',
    },
    'newTriage': {
      'en': 'New Triage',
      'mr': 'नवीन तपासणी',
    },
    'findFacility': {
      'en': 'Find Facility',
      'mr': 'रुग्णालय शोधा',
    },
    'trackReferral': {
      'en': 'Track Referral',
      'mr': 'संदर्भ ट्रॅक करा',
    },

    // Patient Registration
    'patientRegistrationTitle': {
      'en': 'New Patient Registration',
      'mr': 'नवीन रुग्ण नोंदणी',
    },
    'fullName': {
      'en': 'Full Name',
      'mr': 'पूर्ण नाव',
    },
    'age': {
      'en': 'Age',
      'mr': 'वय',
    },
    'gender': {
      'en': 'Gender',
      'mr': 'लिंग',
    },
    'male': {
      'en': 'Male',
      'mr': 'पुरुष',
    },
    'female': {
      'en': 'Female',
      'mr': 'स्त्री',
    },
    'otherGender': {
      'en': 'Other',
      'mr': 'इतर',
    },
    'mobile': {
      'en': 'Mobile Number',
      'mr': 'मोबाईल क्रमांक',
    },
    'village': {
      'en': 'Village / Town',
      'mr': 'गाव / शहर',
    },
    'district': {
      'en': 'District',
      'mr': 'जिल्हा',
    },
    'emergencyContact': {
      'en': 'Emergency Contact',
      'mr': 'आपत्कालीन संपर्क',
    },
    'abhaId': {
      'en': 'ABHA ID (Optional)',
      'mr': 'आभा आयडी (पर्यायी)',
    },
    'btnRegisterPatient': {
      'en': 'REGISTER PATIENT',
      'mr': 'रुग्ण नोंदणी करा',
    },

    // Clinical Intake & Symptoms
    'clinicalIntakeTitle': {
      'en': 'Clinical Intake & Emergency Vitals',
      'mr': 'वैद्यकीय तपासणी आणि जीवनचिन्हे',
    },
    'patientInfo': {
      'en': 'Patient Information',
      'mr': 'रुग्ण माहिती',
    },
    'symptoms': {
      'en': 'Presenting Symptoms',
      'mr': 'लक्षणे',
    },
    'vitals': {
      'en': 'Vital Signs',
      'mr': 'जीवनचिन्हे',
    },
    'chestPain': {
      'en': 'Chest Pain',
      'mr': 'छातीत दुखणे',
    },
    'breathlessness': {
      'en': 'Breathlessness',
      'mr': 'श्वास घेण्यास त्रास',
    },
    'fever': {
      'en': 'Fever',
      'mr': 'ताप',
    },
    'trauma': {
      'en': 'Trauma / Accident',
      'mr': 'अपघात / जखम',
    },
    'weakness': {
      'en': 'Weakness / Dizziness',
      'mr': 'अशक्तपणा / चक्कर',
    },
    'bleeding': {
      'en': 'Bleeding',
      'mr': 'रक्तस्त्राव',
    },
    'otherSymptom': {
      'en': 'Other Symptoms',
      'mr': 'इतर लक्षणे',
    },
    'heartRate': {
      'en': 'Heart Rate (BPM)',
      'mr': 'हृदयाचे ठोके (BPM)',
    },
    'bloodPressure': {
      'en': 'Blood Pressure (BP)',
      'mr': 'रक्तदाब (BP)',
    },
    'systolic': {
      'en': 'Systolic (mmHg)',
      'mr': 'सिस्टोलिक (mmHg)',
    },
    'diastolic': {
      'en': 'Diastolic (mmHg)',
      'mr': 'डायस्टोलिक (mmHg)',
    },
    'spo2': {
      'en': 'SpO₂ (%)',
      'mr': 'ऑक्सिजन प्रमाण (SpO₂ %)',
    },
    'temperature': {
      'en': 'Temperature (°F)',
      'mr': 'तापमान (°F)',
    },
    'respiratoryRate': {
      'en': 'Respiratory Rate (breaths/min)',
      'mr': 'श्वसन दर (प्रति मिनिट)',
    },
    'consciousness': {
      'en': 'Consciousness Level (AVPU)',
      'mr': 'शुद्धीची पातळी (AVPU)',
    },
    'runTriage': {
      'en': 'RUN TRIAGE',
      'mr': 'तपासणी सुरू करा',
    },

    // Triage Result
    'triageResultTitle': {
      'en': 'Triage Evaluation Result',
      'mr': 'प्राथमिक तपासणी निष्कर्ष',
    },
    'emergency': {
      'en': 'EMERGENCY',
      'mr': 'आपत्कालीन',
    },
    'urgent': {
      'en': 'URGENT',
      'mr': 'तातडीचे',
    },
    'routine': {
      'en': 'ROUTINE',
      'mr': 'नियमित',
    },
    'riskFactors': {
      'en': 'Identified Risk Factors',
      'mr': 'ओळखलेले धोक्याचे घटक',
    },
    'recommendedReferral': {
      'en': 'Recommended Immediate Referral',
      'mr': 'शिफारस केलेले तातडीचे संदर्भ रुग्णालय',
    },
    'timestamp': {
      'en': 'Assessment Timestamp',
      'mr': 'तपासणी वेळ',
    },
    'triageDisclaimer': {
      'en': 'This is a decision-support prototype, NOT an autonomous medical diagnosis system.',
      'mr': 'हा निर्णय-सपोर्ट प्रोटोटाइप आहे, हा स्वायत्त वैद्यकीय निदान प्रणाली नाही.',
    },
    'btnFindFacility': {
      'en': 'FIND BEST FACILITIES',
      'mr': 'योग्य रुग्णालये शोधा',
    },

    // Facility Ranking
    'bestFacilitiesTitle': {
      'en': 'BEST FACILITIES FOR THIS PATIENT',
      'mr': 'या रुग्णासाठी सर्वोत्तम रुग्णालये',
    },
    'distance': {
      'en': 'Distance',
      'mr': 'अंतर',
    },
    'eta': {
      'en': 'ETA',
      'mr': 'अंदाजे वेळ',
    },
    'icuBeds': {
      'en': 'ICU Beds',
      'mr': 'आयसीयू खाटा',
    },
    'oxygenBeds': {
      'en': 'Oxygen Beds',
      'mr': 'ऑक्सिजन खाटा',
    },
    'ventilators': {
      'en': 'Ventilators',
      'mr': 'व्हेंटिलेटर',
    },
    'specialty': {
      'en': 'Specialty',
      'mr': 'विशेष उपचार',
    },
    'equipment': {
      'en': 'Equipment',
      'mr': 'उपकरणे',
    },
    'availability': {
      'en': 'Availability',
      'mr': 'उपलब्धता',
    },
    'available': {
      'en': 'AVAILABLE',
      'mr': 'उपलब्ध',
    },
    'requestBed': {
      'en': 'REQUEST BED',
      'mr': 'खाट विनंती करा',
    },

    // Bed Reservation
    'bedReservationTitle': {
      'en': 'Bed Reservation & Admission',
      'mr': 'खाट आरक्षण आणि भरती',
    },
    'patient': {
      'en': 'Patient',
      'mr': 'रुग्ण',
    },
    'urgency': {
      'en': 'Urgency Level',
      'mr': 'तातडीची पातळी',
    },
    'requiredSpecialty': {
      'en': 'Required Specialty',
      'mr': 'आवश्यक विशेष विभाग',
    },
    'requiredEquipment': {
      'en': 'Required Equipment',
      'mr': 'आवश्यक उपकरणे',
    },
    'estimatedArrival': {
      'en': 'Estimated Arrival',
      'mr': 'अपेक्षित आगमन',
    },
    'hospitalCapacity': {
      'en': 'Hospital Capacity',
      'mr': 'रुग्णालय क्षमता',
    },
    'acceptAndReserve': {
      'en': 'ACCEPT & RESERVE',
      'mr': 'स्वीकारा आणि आरक्षित करा',
    },
    'reject': {
      'en': 'REJECT',
      'mr': 'नाकारा',
    },
    'reserved': {
      'en': 'RESERVED',
      'mr': 'आरक्षित',
    },
    'bedReservedConfirmation': {
      'en': 'Bed successfully reserved for incoming patient.',
      'mr': 'येणाऱ्या रुग्णासाठी खाट यशस्वीरीत्या आरक्षित करण्यात आली आहे.',
    },
    'dispatchAndTrack': {
      'en': 'DISPATCH & TRACK REFERRAL',
      'mr': 'रुग्णवाहिका पाठवा आणि ट्रॅक करा',
    },

    // Referral Tracking Timeline
    'referralTrackingTitle': {
      'en': 'Inter-Facility Referral Tracking',
      'mr': 'रुग्णालय संदर्भ ट्रॅकिंग',
    },
    'submitted': {
      'en': 'SUBMITTED',
      'mr': 'सादर केले',
    },
    'accepted': {
      'en': 'ACCEPTED',
      'mr': 'स्वीकृत',
    },
    'bedReserved': {
      'en': 'BED RESERVED',
      'mr': 'खाट आरक्षित',
    },
    'inTransit': {
      'en': 'IN TRANSIT',
      'mr': 'वाटेत आहे',
    },
    'arrived': {
      'en': 'ARRIVED',
      'mr': 'पोहोचले',
    },
    'completed': {
      'en': 'COMPLETED',
      'mr': 'पूर्ण झाले',
    },
    'referralId': {
      'en': 'Referral ID',
      'mr': 'संदर्भ आयडी',
    },
    'origin': {
      'en': 'Origin Facility',
      'mr': 'मूळ आरोग्य केंद्र',
    },
    'destination': {
      'en': 'Destination Hospital',
      'mr': 'गंतव्य रुग्णालय',
    },
    'ambulance': {
      'en': 'Ambulance',
      'mr': 'रुग्णवाहिका',
    },
    'currentStatus': {
      'en': 'Current Status',
      'mr': 'सध्याची स्थिती',
    },

    // Ambulance Screen
    'ambulanceTrackingTitle': {
      'en': 'EMS & Ambulance Tracking',
      'mr': '१०८ रुग्णवाहिका ट्रॅकिंग',
    },
    'driver': {
      'en': 'Driver / Pilot',
      'mr': 'चालक / पायलट',
    },
    'currentLocation': {
      'en': 'Current GPS Location',
      'mr': 'सध्याचे जीपीएस स्थान',
    },
    'confirmHandover': {
      'en': 'CONFIRM ARRIVAL & HANDOVER',
      'mr': 'आगमन आणि हस्तांतरण निश्चित करा',
    },

    // Hospital Dashboard
    'hospitalDashboardTitle': {
      'en': 'Hospital Live Bed Matrix',
      'mr': 'रुग्णालय थेट खाट डॅशबोर्ड',
    },
    'totalBeds': {
      'en': 'Total Beds',
      'mr': 'एकूण खाटा',
    },
    'incomingReferrals': {
      'en': 'Incoming Referrals',
      'mr': 'येणारे संदर्भ रुग्ण',
    },
    'reserveBed': {
      'en': 'Reserve Bed',
      'mr': 'खाट आरक्षित करा',
    },

    // Patient History
    'patientHistoryTitle': {
      'en': 'Patient Medical History',
      'mr': 'रुग्णाचा वैद्यकीय इतिहास',
    },
    'previousReferrals': {
      'en': 'Previous Referrals',
      'mr': 'मागील संदर्भ',
    },
    'triageAssessments': {
      'en': 'Triage Assessments',
      'mr': 'प्राथमिक तपासण्या',
    },
    'hospitalTransfers': {
      'en': 'Hospital Transfers',
      'mr': 'रुग्णालय हस्तांतरणे',
    },
  };

  static String get(String key, AppLanguage lang) {
    return _localizedValues[key]?[lang.code] ?? 
           _localizedValues[key]?['en'] ?? 
           key;
  }
}
