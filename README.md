
# GOATZ Demo (Flutter)

This is a self-contained demo of the GOATZ app you can run without Firebase.

## Run (Web)
1) Install Flutter (3.x)
2) In this folder:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

The demo includes:
- Matchups page with tap-to-flip cards and swipe to vote (re-picks locally)
- Leaderboard (demo ratings)
- Daily Challenge with live client-side results
- Profile (sample lists)

When you’re ready for Firebase, set `kDemoMode = false` and swap the repository to a Firestore-backed one.
