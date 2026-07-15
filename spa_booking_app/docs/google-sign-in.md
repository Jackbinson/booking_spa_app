# Google Sign-In

The app sends a Google ID token to `POST /api/v1/auth/google`. The API verifies
the token with Google, creates or links a customer account, then returns the
existing JWT session payload.

## Backend

Set the OAuth **Web application** client ID in `Booking_spa_be/.env`:

```dotenv
GOOGLE_OAUTH_CLIENT_ID=1234567890-example.apps.googleusercontent.com
```

Run the database migration before deploying the endpoint:

```bash
cd Booking_spa_be
pnpm db:migrate
```

## Flutter run configuration

Use OAuth client IDs created for the matching application/platform. Android
needs the web/server client ID when no `google-services.json` is used. iOS and
macOS need their platform client ID plus the web/server client ID.

```bash
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=1234567890-example.apps.googleusercontent.com \
  --dart-define=GOOGLE_WEB_CLIENT_ID=1234567890-example.apps.googleusercontent.com \
  --dart-define=GOOGLE_IOS_CLIENT_ID=1234567890-ios-example.apps.googleusercontent.com
```

For Flutter web, add the exact development and production origins in Google
Cloud's **Authorized JavaScript origins**. For iOS, also add the reversed iOS
client ID URL scheme to `ios/Runner/Info.plist` before release.
