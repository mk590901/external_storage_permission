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
* The __AsyncPathExistFuture__ class is designed to check whether the requested folder path exists in shared memory, and the __AsyncFilesFuture__ class allows you to get a list of files of the given folder, including subfolders.
  
As a matter of fact, the five mentioned classes are responsible for the technical solution. All that’s left to do is to glue these methods into a sequence of operations and ensure that the final result is obtained at the __one click__ of a button.

## Implementation

I was able to chain the above operations into a sequence of calls to five asynchronous futures built into the state machine below. The latter is associated with a specially created class called __AccessBloc__. In this decision I used __trans__(__ition__)- functions, which are called when moving from one state to another in state machines under the influence of event and run callback functions passed as parameter to event. Can also notice that uses AsyncProcess objects that run callbacks don't use __await__ operators. I.e. absolutely all operations are asynchronous.

## State Machine

![permissions sample (3)](https://github.com/mk590901/external_storage_permission/assets/125393245/53fd9798-7d17-4344-ad07-84a8274075e6)

## Movie

The movie below illustrates this approach. Access to publc Downloads and Documents folders has been implemented. 

https://github.com/mk590901/external_storage_permission/assets/125393245/a9ec8bd5-9a04-42d1-a445-0efcadc2838e

