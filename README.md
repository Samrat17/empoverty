
# Empoverty (Flutter)

## Quick start
1. `flutter pub get`
2. Add Firebase config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
3. Android Gradle: apply Google services plugin as usual.
4. Run: `flutter run`

## Notes
- Maps: uses OpenStreetMap via `flutter_map` (no API key).
- Reverse geocoding: uses `geocoding` plugin (platform services).
- External navigation: launches device maps via `geo:` or falls back to `maps.google.com`.
