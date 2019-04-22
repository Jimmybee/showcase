# Showcase #

## Purpose
This a general purpose project to be used in place of sample project requests. It covers some key areas but like many projects there is much that I would wish to include; listed at the bottom of this Readme.

## Overview
The app contains a tab bar controller with 2 distinct parts. One part fetches dummy JSON data from 
https://jsonplaceholder.typicode.com whilst the second allows the user to search by artist or select a genre to display album art from ITunes.

Disclaimer: 
 - Using Core Data, Realm, Url Session, Moya, NSConstraints, SnapKit, Nibs and Storyboard all together isn't really neccessary but this is a showcase and I can, so I did.
 - The JSON placeholder part has little to no design, with all the interesting stuff in the code
 - The ITunes music part contains some animated elements.

Generally, I have focussed on showing the most common tasks done in mobile applications:
  - REST API and JSON parsing
  - Data persistance 
  - Table & Collection views
  - Animated views
  - Debug & Error logging
  
Additional elements:
  - Localization
  - Reuseable nibs

The JSON placeholder models utilise protocols to interchangeably use Core Data, Realm, URL Session or Moya Provider.
There are both is both a reactive and imperative view controller version that makes use of these protocols.

## Unfinished business - Future Work
- Link artist to album list
- Loading spinner for posts lists, and refresh button
- Groups posts by user. 
- Animated table expand/collapse on user tap
- Unit tests for view models
- UI Tests
- Fastlane
- Continuous Integration
- Recreate ITunesSearch with RxViewModel
- Firebase error logging
- Create local posts
- Firestore backend to store posts
- Firestore facebook login

