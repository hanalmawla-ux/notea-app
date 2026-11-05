# بناء ملف AAB لتطبيق Notea

**مهم:** ما قدرت أبني ملف الـAAB نفسه من عندي، لأن بيئتي ما بتوصل لسيرفرات Android SDK وGradle وMaven اللازمة للبناء. فجهّزت لك مشروع أندرويد كامل (مجلد `android/`) مع إعداد التوقيع، وملف بناء أوتوماتيكي على GitHub. بتاخد الـAAB بإحدى الطريقتين تحت. المشروع ما انبنى ولا انجرّب بالفعل.

معلومات التطبيق: الاسم Notea، المعرّف (applicationId) `com.notea.app`، الإصدار 1.0 (versionCode 1)، targetSdk 36، minSdk 24.
**قبل أول رفع على Google Play** قرر المعرّف النهائي، لأنه ما بيتغير بعدين. للتغيير: عدّل `appId` في `capacitor.config.json`، احذف مجلد `android/`، ثم `npx cap add android` وأعد توليد الأيقونات، وأعد إضافة إعداد التوقيع في `android/app/build.gradle`.

## 0) مفتاح التوقيع (مرة وحدة)
Google Play بيطلب AAB موقّع. أنشئ المفتاح بأحد الطريقتين:
- من الطرفية (بتحتاج JDK): `./make-keystore.sh`
- أو من Android Studio: Build ← Generate Signed App Bundle ← Create new...

**احتفظ بملف `notea-release.jks` وكلمات السر بمكان آمن**، وإذا ضاعوا ما بتقدر تحدّث التطبيق. ولا ترفعهم على GitHub (مضافين لـ `.gitignore`).

## الطريقة 1: GitHub Actions (بدون تثبيت Android Studio)
1. أنشئ مستودع على GitHub وارفع فيه كل ملفات هالمجلد (بدون `node_modules`).
2. من Settings ← Secrets and variables ← Actions، أضف 4 أسرار:
   - `ANDROID_KEYSTORE_BASE64`: محتوى الملف `notea-release.jks.base64.txt`
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS`: الاسم `notea` إذا استعملت السكربت
   - `ANDROID_KEY_PASSWORD`
3. من تبويب Actions اختر **Build Notea AAB** ← Run workflow.
4. بعد دقائق حمّل `notea-aab` من صفحة التشغيل، وجواته `app-release.aab`.

## الطريقة 2: Android Studio
```
npm install
npx cap sync android
npx cap open android
```
ثم Build ← Generate Signed App Bundle / APK ← Android App Bundle، واختر مفتاحك.

## الطريقة 3: سطر الأوامر (JDK 21 + Android SDK)
انسخ `android/keystore.properties.example` إلى `android/keystore.properties` وعبّي بياناتك، ثم:
```
npm install
npx cap sync android
cd android && ./gradlew bundleRelease
```
الناتج: `android/app/build/outputs/bundle/release/app-release.aab`
(بدون مفتاح بيطلع AAB غير موقّع وGoogle Play ما بيقبله).

## عند النشر على Google Play
- بتحتاج حساب مطوّر في Play Console (رسم تسجيل لمرة وحدة).
- كل رفع جديد لازم `versionCode` أعلى: عدّله في `android/app/build.gradle`.
- بتحتاج صفحة سياسة خصوصية وصور للمتجر. وحسابات المطورين الشخصية الجديدة ممكن تتطلب فترة اختبار مغلق قبل النشر العام، فتأكد من شروط Google الحالية.
- بعد تعديل أي شي في `www/` شغّل `npx cap sync android` قبل البناء.

## ملاحظات
- الخطوط (Inter وReadex Pro) بتتحمّل من الإنترنت، وبدونه بيستعمل التطبيق خط الهاتف.
- زر «مشاركة / حفظ» في ميزة الخلفية ممكن ما يشتغل داخل WebView أندرويد، والبديل الضغط مطولاً على الصورة. لدعم المشاركة الأصلية أضف الإضافة `@capacitor/share`.
- الملاحظات محفوظة على الجهاز فقط (بدون مزامنة).
