# Build a release android version

## Installing Android SDK

```bash
flutter doctor
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
curl -fSLO https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
mkdir -p ~/Android/Sdk/cmdline-tools
unzip commandlinetools-linux-6858069_latest.zip -d ~/Android/Sdk/cmdline-tools
mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc
sdkmanager --licenses
sdkmanager --update
sdkmanager "platforms;android-33" "build-tools;33.0.0" "platform-tools"
flutter doctor
```

## Generating key.jks

1. **Generate a key store**: 
Open your terminal and run the following command:

```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

This command generates a keystore named `key.jks` in your home directory with a key named `key`. `-validity 10000` specifies that the key pair is valid for 10000 days.

You'll be asked to enter a keystore password, and then a key password, which you should save for later use. You'll also need to fill in some information about your organization. 

2. **Reference the keystore from the app**: 
Create a file named `/android/key.properties` that contains a reference to your keystore:

```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=/home/<username>/key.jks>
```

Make sure to add `key.properties` to your `.gitignore` file to prevent it from being committed to your version control system.

3. **Configure signing in gradle**: 
Update the `android/app/build.gradle` file in your app to include a reference to your keystore:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            ...
        }
    }
}
```

This will configure the Android build system to use your signing configuration for release builds. 

Remember, you should safeguard your keystore and its associated passwords carefully, as they are needed to sign your app. If you lose them, you won't be able to release updates to your app on the Play Store because the new version wouldn't be signed with the same key as the previous version.

## Building the app

Just run the following command :
```bash
flutter build appbundle --release
```
