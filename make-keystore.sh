#!/usr/bin/env bash
# Creates your release signing key. KEEP notea-release.jks AND ITS PASSWORDS SAFE - losing them means you cannot update the app.
set -e
keytool -genkeypair -v -keystore notea-release.jks -alias notea -keyalg RSA -keysize 2048 -validity 10000
base64 notea-release.jks | tr -d '\n' > notea-release.jks.base64.txt
echo "Done. Use the content of notea-release.jks.base64.txt as the ANDROID_KEYSTORE_BASE64 secret on GitHub."
