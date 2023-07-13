# Dronos UTM (iOS)

![Mockup](https://raw.githubusercontent.com/Aerodyne-Group/DronosUTM-iOS/main/mockup.png?token=GHSAT0AAAAAACE43GDIGFJZ4XTC7VZ2UIECZFPPOLQ)

Mobile version for Dronos UTM.
This project is mainly using  [MapBox SDK](https://docs.mapbox.com/ios/maps) and [DJI Mobile SDK](http://developer.dji.com/mobile-sdk/).

## Get Started Immediately

### Dronos UTM Installation with CocoaPods

Since this project has been integrated with [DJI iOS UX SDK CocoaPods](https://cocoapods.org/pods/DJI-UXSDK-iOS) now, please check the following steps to install **DJISDK.framework** using CocoaPods after you downloading this project:

**1.** Install CocoaPods

Open Terminal and change to the download project's directory, enter the following command to install it:

~~~
sudo gem install cocoapods
~~~

The process may take a long time, please wait. For further installation instructions, please check [this guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).

**2.** Install Dronos UTM and DJIWidget with CocoaPods in the Project

Run the following command in the **SwiftCode** paths:

~~~
pod install
~~~

If you install it successfully, you should get the messages similar to the following:

~~~
Analyzing dependencies
Downloading dependencies
Installing DJI-SDK-iOS (4.16)
Installing DJI-UXSDK-iOS (4.16)
Installing DJIWidget (1.6.6)
Installing DJIFlySafeDatabaseResource (01.00.01.18)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `DronosUTM.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod
installed.
~~~

> **Note**: If you saw "Unable to satisfy the following requirements" issue during pod install, please run the following commands to update your pod repo and install the pod again:
>
> ~~~
> pod repo update
> pod install
> ~~~


**3.** Setup Mapbox

Open Terminal and change to the home directory, enter the following command to install it:

~~~
vi .netrc
~~~

Then paste this below code

~~~
machine api.mapbox.com
login mapbox
password <secret key>
~~~

**Note** Please take note it is secret key not a token key. **Secret key** look like this (sk.eyJ1IjoienZoaXI5OCIsIm.......) while **Token key** look like this (pk.Gp6YnczaGYwM2p6Mm.......)


### Run Sample Code

Developers will need to set up the App Key by editing the sample code's info.plist, [after generating their unique App Key](https://developer.dji.com/mobile-sdk/documentation/quick-start/index.html#generate-an-app-key).

For the Swift sample app, the **DJISDKAppKey** is present in the "Info.plist" - developers just need to add their unique key.
In both cases, developers will still need to update the [Bundle Identifier](http://developer.dji.com/user/mobile-sdk/ios-configuration/).

One of DJI's aircraft or handheld cameras will be required to run the sample application.

## Learn More about Dronos UTM

Please visit [Dronos UTM Web Version](https://dev.dronos.ai/) for more details.

## Development Workflow

From registering as a developer to deploying an application, the following will take you through the full Mobile SDK Application development process:

- [Prerequisites](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-prerequisits.html)
- [Register as DJI Developer & Download SDK](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-register.html)
- [Integrate SDK into Application](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-integrate.html)
- [Run Application](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-run.html)
- [Testing, Profiling & Debugging](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-testing.html)
- [Deploy](https://developer.dji.com/mobile-sdk/documentation/application-development-workflow/workflow-deploy.html)

## Feedback

We’d love to have your feedback as soon as possible. Reach out to us when you hit roadblocks or want to talk through something. At a minimum, please let us know:

- What improvements would you like to see?
- What is hard to use or inconsistent with your expectations?
- What is good?
- Any bugs you come across.
