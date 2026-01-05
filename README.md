# Purrsonal

## To Run on Android device
### On Host/VM run
1. Install [Android Platform Tools](https://developer.android.com/tools/releases/platform-tools) or `apt install android-tools-adb`
3. Connect the device to USB
4. Run `adb devices`
    - The device will prompt you to authorize the computer.
    - Tap “Allow”/“Always allow from this computer”.
5. Get device IP: `adb shell ip addr show wlan0`
6. Enable TCP/IP mode with: `adb tcpip 5555`
7. Disconnect USB and connect over WiFi `adb connect <device-ip>:5555`
8. Verify connection: `adb devices`

### Inside DevContainerf
1. Connect to the device over Wi-Fi: `adb connect <device-ip>:5555`
    - The device will prompt you to authorize the computer.
    - Tap “Allow”/“Always allow from this computer”.
2. Verify connection: `adb devices`
3. Make sure Flutter sees the device: `flutter devices`
4. Run your app with `flutter run` or run `main.dart` from VSCode