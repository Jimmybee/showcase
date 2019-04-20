# Showcase #

## Purpose
This a general purpose project to be used in place of sample project requests. It already covers a lot but many projects, there is much that I would wish to include, listed at the bottom of this Readme.

## Overview
I have focussed on showing the most common tasks done in mobile applications:
  - REST API and JSON parsing
  - Data persistance 
  - Table & Collection views
  - Animated views
  - Debug & Error logging
  
Additional elements:
  - Localization
  - Reuseable nibs

There is two unrelated data sets, which is not unusual for an application
  - JSON Placeholder posts
  - ITunes Music

Although there are only a few views, they utilise protocols to interchangeably use Core Data, Realm, URL Session or Moya Provider, with generic callbacks and observables for models.

The JSON Placeholder is also rewritten with a reactive view controller and view model; although such incosistency of methods would be unadvisable in a real project.

## Additional plans
- Loading spinner for posts lists, and refresh button
- Groups posts by user. 
- Animated table expand/collapse on user tap
- Unit tests for view models
- UI Tests
- Recreate ITunesSearch with RxViewModel
- Firebase error logging
- Create local posts
- Firestore backend to store posts
- Firestore facebook login

