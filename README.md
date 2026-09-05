# संजीवन महा-नेट (CareConnect Maharashtra)
### *“From first contact to completed care.”*

**Smart India Hackathon HealthTech Prototype**  
*Emergency Triage, Facility Discovery, Real-Time Bed Reservation & Inter-Facility Referral Coordination*  
**Client/Stakeholder:** Public Health Department, Government of Maharashtra

---

## 🌟 Executive Overview

In rural and semi-urban Maharashtra, critical delays occur during emergency transfers between Primary Health Centres (PHCs) and tertiary hospitals due to lack of real-time ICU bed visibility, uncoordinated ambulance dispatch, and unstructured clinical handovers.

**संजीवन महा-नेट (CareConnect Maharashtra)** solves this with a unified digital highway connecting:
1. **Medical Officers (PHC / Rural Hospitals)**: Rapid patient intake, algorithmic emergency triage, and facility capability matching.
2. **Hospital Bed Managers (District & Tertiary Hospitals)**: Live bed capacity matrix (ICU, Oxygen, Ventilators) and one-tap bed locking.
3. **108 EMS & Ambulance Pilots**: Live GPS route tracking, telemetry, and structured clinical handovers.
4. **Patients & Citizens**: Ayushman Bharat Health Account (ABHA) digital card, 108 emergency hotline, and live referral timeline tracking.

---

## 🚀 Key Technologies & Architecture

- **Framework**: Flutter 3 (Dart 3)
- **Design System**: Material 3 (Maharashtra GovTech Deep Teal & Navy Palette)
- **State Management**: Flutter Riverpod (`flutter_riverpod: ^2.5.1`)
- **Navigation & Routing**: GoRouter (`go_router: ^14.2.0`)
- **REST API & Networking**: Dio (`dio: ^5.4.3+1`) with interceptors and base configurations
- **Secure Storage**: `flutter_secure_storage: ^9.2.2`
- **Mapping & GIS**: Flutter Map (`flutter_map: ^7.0.2`) with OpenStreetMap tiles & polylines
- **Bilingual Engine**: Instant **English ⇄ Marathi (मराठी)** toggle across all screens

### Clean Architecture Directory Layout

```
lib/
├── core/
│   ├── constants/       # AppColors, AppConstants (Districts, Tags), AppStyles
│   ├── theme/           # Material 3 lightTheme (Teal/Navy GovTech palette)
│   └── utils/           # IdGenerator (MH-DIST-YYYY-XXXX), DateFormatter
├── localization/        # AppLanguage, AppStrings (Bilingual Marathi & English), languageProvider
├── models/              # UserModel, PatientModel, VitalsModel, TriageResultModel, FacilityModel, ReferralModel
├── services/            # ApiService (Dio), StorageService (SecureStorage), TriageRuleEngine
├── mock_data/           # MockFacilities (Pune, Sassoon, Shirur, etc.), MockPatients, MockReferrals
├── repositories/        # IAuthRepository, IPatientRepository, IFacilityRepository, IReferralRepository
├── providers/           # Riverpod StateNotifiers & FutureProviders
├── widgets/
│   ├── common/          # StatusBadge, EmergencyBanner, DashboardMetricCard, LanguageToggleButton
│   ├── patient/         # PatientCard
│   ├── triage/          # VitalCard, TriageResultCard
│   ├── facility/        # FacilityCard, BedStatusCard
│   └── referral/        # ReferralTimeline
├── screens/
│   ├── splash/          # Splash branding & animated emblem
│   ├── auth/            # Multi-role Login & Quick Demo Login
│   ├── dashboard/       # Medical Officer, Hospital Live Bed Matrix, Patient Portal
│   ├── patient/         # Patient Registration, Clinical Intake, Patients List, Patient History
│   ├── triage/          # Triage Result Card & Risk Factors
│   ├── facility/        # Facility Ranking & Bed Reservation
│   ├── referral/        # Referral Tracking & Referral Feed
│   ├── ambulance/       # Live GPS OpenStreetMap EMS Route & Handover
│   └── profile/         # User Profile & Instant Role Switcher
└── routing/             # AppRouter (GoRouter setup with 16 routes)
```

---

## 🩺 Clinical Decision-Support Triage Engine

> [!NOTE]
> **Statutory Notice**: This system is designed as an algorithmic clinical decision-support prototype to augment physician triage, NOT as an autonomous medical diagnosis machine.

The rule engine (`TriageRuleEngine`) computes urgency based on physiological criteria:
- **EMERGENCY (Crimson Red)**:
  - Critical Hypoxia: $\text{SpO}_2 < 90\%$
  - Hypotensive Shock: $\text{Systolic BP} < 90\text{ mmHg}$
  - Hypertensive Crisis: $\text{Systolic BP} \ge 180\text{ mmHg}$
  - Severe Tachycardia: $\text{Heart Rate} > 125\text{ bpm}$ or Bradycardia $< 45\text{ bpm}$
  - Acute Coronary Syndrome (Severe Chest Pain + Tachycardia / Desaturation)
  - Unresponsive / Low GCS (AVPU scale)
- **URGENT (Warning Amber)**:
  - Moderate Hypoxemia ($\text{SpO}_2\text{ 90–94\%}$)
  - High Fever with weakness ($> 101^\circ\text{F}$)
  - Hemodynamically stable fractures
- **ROUTINE (Emerald Green)**:
  - Normal physiological vitals and localized complaints

---

## 🔄 6-Stage Referral Lifecycle

```
[1. SUBMITTED] ➔ [2. ACCEPTED] ➔ [3. BED RESERVED] ➔ [4. IN TRANSIT] ➔ [5. ARRIVED] ➔ [6. COMPLETED]
```

1. **SUBMITTED**: Medical Officer files emergency intake and dispatches referral request.
2. **ACCEPTED**: Destination Hospital triage officer reviews clinical risk factors and accepts admission.
3. **BED RESERVED**: Specific bed (e.g. `ICU-B04`) is locked with equipment standby.
4. **IN TRANSIT**: 108 ALS Ambulance is dispatched; live GPS coordinates streamed.
5. **ARRIVED**: Ambulance reaches emergency resuscitation bay.
6. **COMPLETED**: Structured clinical handover signed off between EMS pilot and ward sister.

---

## ⚡ Connecting with Node.js Backend

The repository pattern allows swapping mock repositories for live Node.js REST endpoints by changing provider bindings in `lib/providers/`:

```dart
// To switch from Mock to live Node.js API:
final patientRepositoryProvider = Provider<IPatientRepository>((ref) {
  // return MockPatientRepository();
  return ApiPatientRepository(api: ref.watch(apiServiceProvider));
});
```

All models feature full `fromJson` and `toJson` serialization compatible with standard Express/NestJS REST endpoints.

---

## 💻 Running the Application

### 1. Install Flutter (if not yet on your system)
```bash
# Using Windows winget:
winget install Google.Flutter
```

### 2. Fetch Packages
```bash
flutter pub get
```

### 3. Run on Chrome Web / Mobile Device
```bash
# Run on Chrome
flutter run -d chrome

# Run on connected Android / iOS device or emulator
flutter run
```

### 4. Run Automated Tests
```bash
flutter test
```

---

## 👥 Hackathon Stakeholder Test Roles

During evaluation, use the **Quick Demo Login** or the **Profile ➔ Role Switcher** to test:
- **Medical Officer**: Dr. Sunil Deshmukh, MBBS (Shirur PHC)
- **Hospital Staff**: Sister Sunita More (District Hospital Pune Bed Manager)
- **Ambulance / EMS**: Sambhaji Shinde (Pilot, ALS 108)
- **Patient**: Ramesh Balasaheb Patil (ABHA: `91-4920-1849-2041`)
