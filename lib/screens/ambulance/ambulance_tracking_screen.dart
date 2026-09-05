import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../localization/app_strings.dart';
import '../../localization/language_provider.dart';
import '../../models/referral_model.dart';
import '../../models/triage_result_model.dart';
import '../../providers/referral_provider.dart';
import '../../widgets/common/language_toggle_button.dart';
import '../../widgets/common/status_badge.dart';

class AmbulanceTrackingScreen extends ConsumerStatefulWidget {
  const AmbulanceTrackingScreen({super.key});

  @override
  ConsumerState<AmbulanceTrackingScreen> createState() => _AmbulanceTrackingScreenState();
}

class _AmbulanceTrackingScreenState extends ConsumerState<AmbulanceTrackingScreen> {
  // Coordinates for Shirur PHC -> District Hospital Pune route
  final LatLng _origin = const LatLng(18.8262, 74.3776); // Shirur PHC
  final LatLng _currentAmbulance = const LatLng(18.6850, 74.0500); // Shikrapur en route
  final LatLng _destination = const LatLng(18.5793, 73.8055); // District Hospital Pune

  bool _isHandoverDone = false;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final activeReferral = ref.watch(activeReferralProvider);

    final referral = activeReferral ??
        ReferralModel(
          id: 'REF-MH-2026-90142',
          patientId: 'MH-PUN-2026-0842',
          patientName: 'Ramesh Balasaheb Patil',
          patientAge: 58,
          patientGender: 'Male',
          originFacility: 'Shirur Primary Health Centre',
          destinationFacility: 'District Hospital Pune (Aundh)',
          assignedAmbulance: 'MH-12-EM-1081 (ALS Unit)',
          ambulanceDriver: 'Sambhaji Shinde',
          driverContact: '+91 98234 56789',
          etaMinutes: 18,
          status: ReferralStatus.inTransit,
          urgency: TriageUrgency.emergency,
          requiredSpecialty: 'Cardiology / ICCU',
          reservedBedId: 'ICU-B04',
          createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 8)),
          events: [],
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.get('ambulanceTrackingTitle', lang)),
        actions: const [
          LanguageToggleButton(isDarkTheme: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Telemetry & Driver Card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.emergencyRedLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.airport_shuttle_rounded, color: AppColors.emergencyRed, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              referral.assignedAmbulance ?? 'MH-12-EM-1081 (108 ALS)',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            Text(
                              'Pilot: ${referral.ambulanceDriver ?? 'Sambhaji Shinde'} • ${referral.driverContact ?? '+91 98234 56789'}',
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge(
                      label: referral.urgency.labelEn,
                      variant: BadgeVariant.emergency,
                      isSmall: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTelemetryBox(
                        label: 'Patient',
                        value: referral.patientName,
                        icon: Icons.person_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTelemetryBox(
                        label: 'ETA Destination',
                        value: '${referral.etaMinutes} min',
                        icon: Icons.timer_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTelemetryBox(
                        label: 'O₂ Saturation',
                        value: '93% (On O2)',
                        icon: Icons.water_drop_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Live Interactive Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _currentAmbulance,
                    initialZoom: 10.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.careconnect.maharashtra',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [_origin, _currentAmbulance, _destination],
                          strokeWidth: 4.5,
                          color: AppColors.inProgressBlue,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        // Origin Marker (PHC)
                        Marker(
                          point: _origin,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: AppColors.deepNavy,
                            size: 36,
                          ),
                        ),
                        // Ambulance Marker (Moving)
                        Marker(
                          point: _currentAmbulance,
                          width: 46,
                          height: 46,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.emergencyRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 8),
                              ],
                            ),
                            child: const Icon(Icons.airport_shuttle, color: Colors.white, size: 22),
                          ),
                        ),
                        // Destination Marker (Hospital)
                        Marker(
                          point: _destination,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.local_hospital,
                            color: AppColors.availableGreen,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Floating Origin -> Destination Route Pill
                Positioned(
                  top: 14,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, size: 16, color: AppColors.deepNavy),
                        const SizedBox(width: 6),
                        const Text('Shirur PHC', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textMuted),
                        ),
                        const Icon(Icons.local_hospital, size: 16, color: AppColors.availableGreen),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'District Hospital Pune',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar: Confirm Handover
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isHandoverDone) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.availableGreenLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.task_alt_rounded, color: AppColors.availableGreen, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Patient Handover Completed. Bed admission active at District Hospital.',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF065F46)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                ElevatedButton.icon(
                  onPressed: _isHandoverDone ? null : _handleHandover,
                  icon: const Icon(Icons.verified_user_rounded),
                  label: Text(AppStrings.get('confirmHandover', lang)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.availableGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleHandover() async {
    final activeReferral = ref.read(activeReferralProvider);
    if (activeReferral != null) {
      await ref.read(referralListProvider.notifier).advanceStatus(
            referralId: activeReferral.id,
            nextStatus: ReferralStatus.completed,
            note: 'EMS Handover completed by pilot Sambhaji Shinde to ICU Staff Sister Sunita More.',
          );
    }
    setState(() => _isHandoverDone = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Handover confirmed! Care transferred to receiving facility.'),
        backgroundColor: AppColors.availableGreen,
      ),
    );
  }

  Widget _buildTelemetryBox({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
