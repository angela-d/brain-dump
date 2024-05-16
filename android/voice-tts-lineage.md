# Enable Voice TTS / Text-to-Speech on Lineage OS
Several versions back, Lineage stopped including a text-to-speech engine.

Simply downloading a new engine didn't work for me; even after rebooting, going to System > Languages > Text-to-speech and  trying to do anything would crash the settings app.

Attempting to use GPS navigation would give the toast notification "Could not start tts engine" (GPS would still work, but without voice prompts)

These notes are what I did to get TTS working on Lineage OS 21 / Android 14.

## Requirements
- [F-Droid](https://f-droid.org/) - FOSS app store for Android -- needed to download the following apps:
    - [RHVoice](https://f-droid.org/en/packages/com.github.olga_yakovleva.rhvoice.android/) - TTS engine
    - [Aurora Store](https://f-droid.org/en/packages/com.aurora.store/) - Google Play wrapper; does not require Google Play
        - [Speech Recognition & Synthesis](https://play.google.com/store/apps/details?id=com.google.android.tts) - Yes this is a Google app (download via Aurora if you do not have the Play Store) - could not get it working without having this app present on the phone
            - :warning: Do not download the latest version (offline download won't work without Google Play services!  You have to install an older version in order to get this capability)
            - I had to go to APKMirror to figure out an older build to manually download using Aurora:
                - 1. Go to [APKMirror for Google's TTS](https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine/) (don't download anything)
                - 2. Navigate to something old, I chose September 6, 2023 since I'm not sure what version Google implemented the Play Store requirement (having tried a few - this was the first one that worked) [Speech Recognition & Synthesis googletts.google-speech-apk_20230807.02_p1.561746158](https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine/google-text-to-speech-engine-googletts-google-speech-apk_20230807-02_p1-561746158-release/)
                    
                    - Note that there are multiple variants -- most phones will be arm64-v8a -- note the version code to the left -- `210441742`
                - 3. Go back to Aurora with your version code
                - 4. In the app listing on Aurora for **Speech Recognition & Synthesis** by Google LLC, click the 3 dots in the upper-right corner > Manual Download > enter the version number -- app should begin downloading

## Steps to Activate TTS on Lineage
1. Download the above apps
2. Reboot the phone
3. Grant them all at the very least wifi access through your firewall (temporarily)
4. In RHVoice, select your preferred languiage and download the voices you want (one or all)
    - You can revoke internet access for RHVoice after, if you want (I didn't find it necessary for voice GPS navigation to work)
5. In Lineage, go to Settings > System > Languages > under Speech, select the settings wheel beside Voice Input
    - Select Add a Language
    - Download your chosen language
    - You can revoke internet access for Speech Recognition & Synthesis, if you want (I didn't find it necessary for voice GPS navigation to work)
6. Under Settings > System > Languages, click Text-to-Speech output -- you should get a prompt to select RHVoice or Google's app, I selected RHVoice and 'Just Once' just to test; you could use either offline, though
7. Open your GPS navigation app (I found [OsmAnd~](https://f-droid.org/en/packages/net.osmand.plus/) to be the easiest) and setup a route, you should hear your text to speech engine give you an arrival estimate!
