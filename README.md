# Flutter and access to public folders in Android

## Introduction

The goal of project is to create a __Flutter__ application that provides access to __public folders__ of __Android__ devices. For example, this application will allow you to get a list of files in the common __Documents__ or __Downloads__ folders.

## Problems

Basically there are two main problems that need to be solved:
* Allow the application to access shared folders.
* Define absolute paths to shared folders

## Solution

* To solve the first problem, need to allow the application access to manage external storage: __android.permission.MANAGE_EXTERNAL_STORAGE__ and possibility for reading/writing files: __android.permission.READ_EXTERNAL_STORAGE__ and __android.permission.WRITE_EXTERNAL_STORAGE__. These permissions must be described in the application manifest __AndroidManifest.xml__. Next, need to use the standard __Flutter__ plugin __permission_handler__ https://pub.dev/packages/permission_handler from __pub.dev__ and from the application request permission to use __android.permission.MANAGE_EXTERNAL_STORAGE__, and select permission. Request is implemented in the __AsyncPermissionRequestFuture__ class in the __process__ method. Can first find out whether access is allowed or not by using the __AsyncPermissionStatusFuture__ class. This will save operations. Pay attention on method __process__.
* To determine absolute paths to shared folders, a plugin was written in __Java__, encapsulated in the __MainActivity__ class and used in the method process in __AsyncExternalPathFuture__ class.


## State Machine

![permissions sample (3)](https://github.com/mk590901/external_storage_permission/assets/125393245/53fd9798-7d17-4344-ad07-84a8274075e6)


## Movie


https://github.com/mk590901/external_storage_permission/assets/125393245/a9ec8bd5-9a04-42d1-a445-0efcadc2838e

