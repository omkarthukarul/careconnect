import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/medical_officer_dashboard.dart';
import '../screens/dashboard/hospital_dashboard.dart';
import '../screens/dashboard/patient_portal_screen.dart';
import '../screens/patient/patient_registration_screen.dart';
import '../screens/patient/clinical_intake_screen.dart';
import '../screens/patient/patients_list_screen.dart';
import '../screens/patient/patient_history_screen.dart';
import '../screens/triage/triage_result_screen.dart';
import '../screens/facility/facility_ranking_screen.dart';
import '../screens/facility/bed_reservation_screen.dart';
import '../screens/referral/referral_tracking_screen.dart';
import '../screens/referral/referral_list_screen.dart';
import '../screens/ambulance/ambulance_tracking_screen.dart';
import '../screens/profile/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/mo-dashboard',
        builder: (context, state) => const MedicalOfficerDashboard(),
      ),
      GoRoute(
        path: '/hospital-dashboard',
        builder: (context, state) => const HospitalDashboard(),
      ),
      GoRoute(
        path: '/ambulance',
        builder: (context, state) => const AmbulanceTrackingScreen(),
      ),
      GoRoute(
        path: '/patient-portal',
        builder: (context, state) => const PatientPortalScreen(),
      ),
      GoRoute(
        path: '/register-patient',
        builder: (context, state) => const PatientRegistrationScreen(),
      ),
      GoRoute(
        path: '/clinical-intake',
        builder: (context, state) => const ClinicalIntakeScreen(),
      ),
      GoRoute(
        path: '/triage-result',
        builder: (context, state) => const TriageResultScreen(),
      ),
      GoRoute(
        path: '/facility-ranking',
        builder: (context, state) => const FacilityRankingScreen(),
      ),
      GoRoute(
        path: '/bed-reservation',
        builder: (context, state) => const BedReservationScreen(),
      ),
      GoRoute(
        path: '/referral-tracking',
        builder: (context, state) => const ReferralTrackingScreen(),
      ),
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const ReferralListScreen(),
      ),
      GoRoute(
        path: '/patients-list',
        builder: (context, state) => const PatientsListScreen(),
      ),
      GoRoute(
        path: '/patient-history',
        builder: (context, state) => const PatientHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.toString()}'),
      ),
    ),
  );
});
