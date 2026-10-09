# SILAGO - Marketplace Barang Preloved Kampus

## Project Info
- **Nama**: SILAGO (Lapak Nego, Sesama Maba)
- **Framework**: Flutter
- **Lokasi**: `C:\PBL\silago`

## Desain System
### Warna
- Primary Green: `#16A34A`
- Primary Green Dark: `#15803D`
- Green Tint: `#DCFCE7`
- Background: `#FAFAFA` (off-white)
- Surface/Card: `#FFFFFF`
- Border: `#EDE7DA`
- Text Primary: `#1F2937`
- Text Secondary: `#78716C`
- Error: `#DC2626`

### Style
- Rounded corners: 12-16px untuk button/card
- Font: Inter
- Button shape: Rounded rectangle (bukan pill)
- Shadow: Lembut

## Struktur Project
```
C:\PBL\silago/
├── lib/
│   ├── main.dart                    # Entry point, routing
│   ├── theme/
│   │   └── app_theme.dart           # Theme & warna terpusat
│   └── screens/
│       ├── splash_screen.dart       # Splash 3 detik → Login
│       ├── login_screen.dart        # Login (Email/NIM + Password)
│       ├── register_screen.dart     # Register (placeholder)
│       └── home_screen.dart         # Home (placeholder)
```

## Fitur yang Sudah Dibuat
### ✅ Splash Screen
- Background off-white (#FAFAFA)
- Logo SILAGO (custom paint, bentuk organik hijau)
- Text "SILAGO" + "Lapak Nego"
- Wave hijau 3 layer di bawah
- Auto redirect ke Login setelah 3 detik

### ✅ Login Screen
- Background off-white (#FAFAFA)
- Form Email/NIM + Password
- Toggle show/hide password
- Link "Lupa password?"
- Tombol "Masuk" hijau (rounded 12px)
- Divider "atau masuk dengan"
- Tombol "Lanjutkan dengan Google" (outline, rounded 12px)
- Link "Belum punya akun? Daftar"
- Validasi: field ga boleh kosong
- Navigate ke Home setelah login

### ✅ Theme Configuration (`lib/theme/app_theme.dart`)
- Semua warna sebagai static const
- ThemeData lengkap untuk MaterialApp
- Button style: rounded 12px (bukan pill)
- Input field: rounded 12px, white background

## Routing
```dart
'/' → SplashScreen
'/login' → LoginScreen
'/register' → RegisterScreen
'/home' → HomeScreen
```

## Yang Belum Dibuat
- [ ] Home Screen lengkap (list produk, bottom nav)
- [ ] Register Screen lengkap
- [ ] Detail Produk
- [ ] Chat
- [ ] Profil
- [ ] Backend API integration

## Catatan Penting
1. **Jangan hardcode warna** - Selalu pakai `AppTheme.primaryGreen`, dll
2. **Background consistency** - Semua screen pakai `#FAFAFA` kecuali card/modal pakai `#FFFFFF`
3. **Button shape** - Rounded 12px, bukan pill (circular 100)
4. **Font** - Pakai Inter, kalau ga ada fallback ke system font

## Command untuk Run
```bash
cd C:\PBL\silago
flutter run
```

## Hot Reload/Restart
- `r` → Hot reload (refresh UI)
- `R` → Hot restart (restart dari splash)
- `Ctrl+C` → Stop aplikasi

## File Penting untuk Dibaca Saat Ganti Akun
1. `lib/theme/app_theme.dart` - Lihat semua warna & theme
2. `lib/main.dart` - Lihat routing
3. `lib/screens/splash_screen.dart` - Lihat custom paint logo & wave
4. `lib/screens/login_screen.dart` - Lihat form & validasi
5. File ini (`PROJECT_SUMMARY.md`)

## Next Steps (Saran)
1. Bikin Home Screen dengan bottom navigation
2. Bikin card component untuk produk
3. Bikin detail produk screen
4. Bikin Register Screen lengkap
5. Setup state management (Provider/Riverpod/Bloc)
6. Sambungkan ke backend API
