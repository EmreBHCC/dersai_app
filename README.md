# DersAI 📚🤖

**DersAI**, öğrencilerin ders süresince çektikleri fotoğrafları dijital ortama aktararak, okunabilir hale getiren akıllı bir mobil uygulamadır. Kullanıcılar, bu fotoğrafları kategorilere ayırabilir, yazı ve görselleri ayrıştırabilir, eksik ya da hatalı OCR verilerini yapay zeka destekli API ile düzenleyebilir ve isterlerse sesi kullanarak not oluşturabilirler. Tüm bu işlevler, ders sonrası tekrar ve verimlilik için optimize edilmiştir.

---

**DersAI** is a smart mobile application that transforms class-related photos taken by students into clean, readable digital notes. Users can categorize their notes, separate text from images using classification, and improve incorrectly read text via AI-powered APIs. It also supports voice input for note creation. All features aim to enhance learning efficiency and post-class review.

---

## ✨ Temel Amaç / Purpose

- 📷 Derste çekilen fotoğrafların dijital hale getirilmesi  
- 📁 Fotoğrafların kategori ya da ders adına göre düzenlenmesi  
- 👁️ OCR ile yazıların algılanması ve yapay zeka destekli düzenleme  
- 🔊 Sesli not alma desteği  
- 🗂️ Görsel ve metin içeriğinin ayrı ayrı saklanması

---

## 🚀 Özellikler / Features

- 📅 Fotoğraf çekme ve OCR ile metin tanıma  
- 🌐 Yapay zeka destekli yazı düzeltme API entegrasyonu  
- 🎮 Yazı/görsel içerik sınıflandırması (classification)  
- ✏️ Notları ders/dosya/kategori şeklinde düzenleme  
- 🔊 Sesli giriş ile not oluşturma  
- 🔐 Firebase Authentication ile kullanıcı kayıt ve girişi

---

## 📄 Kullanılan Teknolojiler / Tech Stack

- Flutter  
- Dart  
- Firebase Authentication  
- Firebase Firestore *(planlanan)*  
- Google ML Kit veya benzeri OCR API *(planlanan)*  
- Konuşma tanıma (Speech-to-Text) API *(planlanan)*

---

## 🛠️ Kurulum / Getting Started

```bash
git clone https://github.com/kullaniciadi/DersAI.git
cd DersAI
flutter pub get
flutterfire configure
flutter run
```

## 🗺️ Yol Haritası / Roadmap

### ✅ Başlangıç Aşaması (Tamamlandı)
- [x] Giriş ve kayıt ekranlarının oluşturulması
- [x] Firebase Authentication entegrasyonu
- [x] Ana sayfa & temel navigasyon yapısı

### 🔄 Geliştirme Aşaması (Devam Ediyor)
- [ ] Fotoğraf çekme ve galeri desteği
- [ ] OCR ile görsellerden yazı çıkarma (Google ML Kit / Firebase ML)
- [ ] Görsel/sınıflandırma işlemleri ile yazı-görsel ayrımı
- [ ] Yapay zeka ile yanlış OCR çıktılarının düzeltilmesi

### 🗣️ Ekstra Özellikler (Planlanıyor)
- [ ] Sesli not alma (speech-to-text API)
- [ ] Dosya/ders/kategori bazlı içerik organizasyonu
- [ ] Notları dışa aktarma / paylaşma (PDF, TXT)
- [ ] Karanlık mod / tema desteği


## 📬 İletişim / Contact

- 📧 E-posta / Email: emrebahceci38@gmail.com  
- 💻 GitHub: [github.com/emrebahceci](https://github.com/EmreBHCC)  
- 💼 LinkedIn: [linkedin.com/in/emrebahceci](https://www.linkedin.com/in/emrebahceci/)


