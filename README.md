Rensselaer Center for Open Source Software:
RPIMobile - http://rcos.rpi.edu/projects/rpi-mobile/

Purpose: 
  The purpose of this app is to build the foundation for a long lasting mobile application that brings all of the great data sources from all around campus into a clean, native format. The project started in the summer of 2012 and has since been rebuilt from the ground up to support ARC, Cocoapods, and several other great additions that will help the longevity of this project.

Goals:
  - First and foremost, my main goal is to build something that will be improved year after year by the students and faculty of RPI. RPI recently released an application for both Android and iOS but it lacks a clean, native interface and has limited functionality. It also relies on a web-based backend for rendering views and would not handle caching and other features that are important for devices not always connected to the internet or RPI's network.
  - This app was released as an open source project for two main purposes. Most importantly, the app should serve as a learning tool for students at other schools/institutions who are trying to build similar applications. It also allows other students to contribute and maintain the project after I leave the project and graduate from RPI.

Features:
  - News Feeds
  - Twitter Feeds
  - Athletics rosters, news, schedules, and results
  - Laundry machine status for on-campus dormitories
  - Shuttle tracker (http://rcos.rpi.edu/projects/mobile-shuttle-tracker/)
  - Directory of student and faculty (http://rcos.rpi.edu/projects/rpi-directory-app/)
  - Video feeds from RPI's YouTube channel

Upcoming features:
  - RPI Event calendar
  - TV Listings for on-campus television services
  - Dining hall menus (currently waiting on an upcoming redesign by Sodexo)
  - Interactive map with building information

Other great ideas:
  - RPI subreddit integration
  - RPI webmail
  - Self-guided tour (GPS based)
  - WRPI streaming (wrpi.org)
  - Local weather forecast
  - SIS integration for grades/eBill
  - Course search (yacs.me API)


Running this code:
  In order to correctly build and run this project, you must open the .xcworkspace file instead of the .xcodeproj due to the cocoapods integration


Team members:
Current:
  - Stephen Silber     (iOS)
  - Stephen Perkins    (iOS)
  - Michael Napolitano (iOS) 

Previous:
  - Colin Steifel      (Android)
  - James McMillan     (Web server)




Libraries used in this project:
  Cocoapods:     https://github.com/CocoaPods/CocoaPods
  PrettyKit:     https://github.com/vicpenap/PrettyKit
  AFNetworking:  https://github.com/AFNetworking/AFNetworking
  JSONKit:       https://github.com/johnezang/JSONKit
  MFSideMenu:    https://github.com/mikefrederick/MFSideMenu
  MKHorizMenu:   https://github.com/MugunthKumar/MKHorizMenuDemo
  SDURLCache:    https://github.com/rs/SDURLCache
  TestFlight:    https://testflightapp.com/
  
