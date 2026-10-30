# AOSP Bluetooth Audio HAL 2.0 for the stock Android 11 vendor

The SEZB1 vendor only ships Samsung's own Bluetooth audio HAL
(`vendor.samsung.hardware.bluetooth.audio@2.1::ISehBluetoothAudioProvidersFactory`),
which only One UI's framework uses. The AOSP Bluetooth stack looks for
`android.hardware.bluetooth.audio@2.x::IBluetoothAudioProvidersFactory`; without
it A2DP source stays disabled and speakers/headphones disconnect right after
pairing.

The stock audio service (`android.hardware.audio.service`, 32-bit) already
registers the optional "Bluetooth Audio API" when it finds
`android.hardware.bluetooth.audio@2.0-impl.so`, and HAL libraries are looked up
in `/odm` before `/vendor`. These three libraries are plain AOSP code built for
Android 11 (VNDK 30), so they link against the VNDK 30 libraries on the device:

| File | SHA-256 |
|---|---|
| lib/hw/android.hardware.bluetooth.audio@2.0-impl.so | 4807cc8abc0ddfb1d1c8c50ea6d3e3bbd31dcb3ff0b571ee139c9c308b3e40f5 |
| lib/hw/audio.bluetooth.default.so | 94410cc2489403099a8a99834d31db5ab2aeea7059e5c6ba2245900b6bd16219 |
| lib/libbluetooth_audio_session.so | 476568348e86b3f7a3dc88012329eb05611679c5159668f0ca919db1ac7fd84b |

Source: Motorola edge (racer) Android 11 vendor,
`motorola/racer_retail/racer:11/RPD31.Q4U-39-26-4/3c874:user/release-keys`
(public dump `erfanoabdi/motorola_racer_dump`, `vendor/lib`). Their only
dependencies are VNDK 30 / LLNDK libraries: android.hardware.audio.common@5.0,
android.hardware.bluetooth.audio@2.0, libaudioutils, libbase, libcutils,
libfmq, libhidlbase, liblog, libutils.
