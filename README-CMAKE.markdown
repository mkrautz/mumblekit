MumbleKit - Generating Xcode 3 compatible project files using CMake
===================================================================

What's this?
------------

This is a document meant to guide you through the process of generating
Xcode 3-compatible project file for MumbleKit using CMake.

Fetching dependencies
---------------------

Before starting your build, you will need to check out the re-
quired submodules.

    $ git submodule init
    $ git submodule update

This will fetch known "working" snapshot of CELT, Speex and
Protocol Buffers for Objective C.

Generating the project file
---------------------------

MumbleKit uses CMake to generate its Xcode project files. If
you're on Mac OS X, you can download CMake from the CMake
website at http://www.cmake.org/. If you're a user of Homebrew,
MacPorts or Fink, there are packages available in there, too.
Note: CMake 2.8.3 or later required.

To generate a MumbleKit.xcodeproj that targets iOS, use:

    $ cmake -G Xcode . -DIOS_BUILD=1

To generate a MumbleKit.xcodeproj that targets Mac OS X, use:

    $ cmake -G Xcode . -DMACOSX_BUILD=1

Building it (Xcode.app)
-----------------------

After generating a MumbleKit.xcodeproj for your platform, open it
and select your prefered configuration (Debug or Release). The default
build configuration for MumbleKit is Release.

Building it (command line)
--------------------------

To build from the command line, do something like this:

        $ xcodebuild -project MumbleKit.xcodeproj -sdk iphoneos4.1 -target BUILD_ALL -configuration Release

How do I include this into my Xcode project? (iOS)
--------------------------------------------------

Note: Building MumbleKit on iOS requires the iOS 4 SDK.

The easiest way to include MumbleKit with your application on iOS
is to drag the MumbleKit.xcodeproj project inside your application's project.

Then, do the following:

 * Make MumbleKitCombined a direct dependency of your application's main
   executable target.

 * Drag libMumbleCombined.a into the 'Link Against Libraries' section of your
   application's main executable target.

 * Add MumbleKit's src directory as a header search path for your application's
   main executable target.

 * Add MumbleKit's dependencies as linked libraries to the executable target:
     - AudioToolbox.framework
     - CFNetwork.framework
     - Security.framework

 * The build should now work.

How do I include this into my Xcode project? (Mac OS X)
-------------------------------------------------------

One way to do this is to include MumbleKit.xcodeproj inside your main project. Then:

 * Make MumbleKit a direct dependency of your chosen target.

 * Add MumbleKit.framework to the 'Link Binary Against Libraries' section of your chosen target.

 * Add a copy build phase. Copy MumbleKit.framework into 'Frameworks'.

 * Add a run script build phase. This is to change the install name id of the Mumble framework, and
   to fix up the path in your own application binary. The script I use is shown below:

        APP=${CONFIGURATION_BUILD_DIR}/Mumble.app
        FWPATH=${APP}/Contents/Frameworks/
        EXECUTABLE=${APP}/Contents/MacOS/Mumble
        install_name_tool -change MumbleKit @executable_path/../Frameworks/MumbleKit.framework/Versions/A/MumbleKit ${EXECUTABLE}

 It's also worth noting that this procedure seemingly only works if you have a shared build directory. For my
 own Xcode setup, I have set up an XcodeBuild directory in my home directory. My Xcode preferences are set up to
 build all projects in this directory. Per-project build directories are inconvenient, because you would have to
 set the path in both your own .xcodeproj and MumbleKit.xcodeproj.

 Note: It *should* be possible to do this would a common build directory in Xcode 3.1.1+, but I have not yet gotten this
 to work myself. If you know how, or you've got this working, throw me a note. Thanks.
