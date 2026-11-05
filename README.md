# Notea

تطبيق ملاحظات ومهام: عربي/إنجليزي، مجلدات، تثبيت، قوائم مهام، صور وإيموجي، ومولّد خلفية هاتف للمهام.
التطبيق ملف واحد (`www/index.html`) بدون أي مكتبات، والبيانات تنحفظ محلياً على الجهاز (localStorage).

## شو في بالمشروع
```
notea/
├─ www/                  ← التطبيق نفسه (هاد اللي بينرفع أو بينلف)
│  ├─ index.html
│  ├─ manifest.webmanifest
│  ├─ sw.js              ← للعمل بدون إنترنت
│  └─ icons/             ← أيقونات 192 / 512 / maskable / apple / favicon
├─ assets/icon-only.png  ← الأيقونة الأصلية 1024×1024 (للتحويل لتطبيق أصلي)
├─ capacitor.config.json ← إعداد Capacitor (اسم التطبيق: Notea)
└─ README.md
```

## الطريقة 1: تطبيق ويب يتثبّت على الهاتف (PWA) — الأسرع
1. ارفع محتوى مجلد `www/` على أي استضافة HTTPS (Netlify، Vercel، GitHub Pages، Cloudflare Pages).
2. افتح الرابط من الهاتف:
   - **أندرويد (Chrome):** القائمة ⋮ ثم «تثبيت التطبيق» أو «إضافة إلى الشاشة الرئيسية».
   - **آيفون (Safari):** زر المشاركة ثم «إضافة إلى الشاشة الرئيسية».
3. بيظهر بأيقونته واسمه Notea وبيفتح بملء الشاشة وبيشتغل بدون إنترنت.

لتجربته على الكمبيوتر قبل الرفع (من داخل `www/`):
```
npx serve .
```

## الطريقة 2: تطبيق أصلي (Android / iOS) عبر Capacitor
تحتاج Node.js، وAndroid Studio للأندرويد، وXcode (على ماك) للآيفون.
```
cd notea
npm init -y
npm i @capacitor/core @capacitor/cli @capacitor/android @capacitor/ios
npx cap add android        # و/أو: npx cap add ios
npx cap sync
npx cap open android       # أو: npx cap open ios
```
لتوليد أيقونات التطبيق بكل الأحجام من `assets/icon-only.png`:
```
npm i -D @capacitor/assets
npx capacitor-assets generate
```
بعدها من Android Studio / Xcode تبني ملف APK/AAB أو تنشره على المتاجر.

## الطريقة 3: نشر على المتاجر بدون كود (PWABuilder)
ارفع الموقع على HTTPS (الطريقة 1) ثم افتح pwabuilder.com، الصق الرابط، وهو بيجهّز لك حزمة أندرويد وآيفون.

## ملاحظات مهمة
- **الخطوط:** التطبيق بيحمّل Inter و Readex Pro من Google Fonts. بدون إنترنت أول مرة بيستعمل خط النظام. لتطبيق أصلي مستقل نزّل الخطين وحطهم داخل `www/` وغيّر الرابط في `<head>`.
- **تحديث التطبيق:** بعد أي تعديل غيّر `VERSION` داخل `sw.js` (مثلاً `notea-v2`) عشان المستخدمين يستلموا النسخة الجديدة.
- **المشاركة (Share / Save) في خلفية الهاتف:** على أندرويد WebView ممكن ما تشتغل، والبديل الضغط مطولاً على الصورة وحفظها. للأصلي بتقدر تضيف إضافة `@capacitor/share`.
- **البيانات:** محفوظة داخل الجهاز فقط، فما في مزامنة بين جهازين. لو بدك حساب ومزامنة لازم خادم وقاعدة بيانات.
- **تغيير الاسم أو المعرّف:** عدّل `appName` و `appId` في `capacitor.config.json`، و`name` في `manifest.webmanifest`.
