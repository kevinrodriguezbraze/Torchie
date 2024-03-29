//
//  TorchieApp.swift
//  Torchie
//
//  Created by Kevin Rodriguez on 1/30/24.
//

import BrazeKit
import BrazeUI
import SwiftUI
import UserNotifications

//In summary, this code sets up and configures the Braze SDK in the AppDelegate class, ensuring that the Braze instance is stored for later use throughout the app's lifecycle.


//Defines a class named AppDelegate that inherits from NSObject and conforms to the UIApplicationDelegate protocol. The AppDelegate is designated as the delegate to manage the application's lifecycle events - handling tasks associated with launching, backgrounding, foregrounding, and termination.
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    //Declares a static property named braze of type Braze? (optional Braze instance). This property is used to store a reference to the Braze instance.
    static var braze: Braze? = nil
    
    // This method is a part of the UIApplicationDelegate protocol and is called when the app is launching. The purpose of this method is to perform any necessary setup tasks before the app is considered fully launched and becomes active.
    //This function takes two parameters:
    //application: An instance of UIApplication. This parameter represents the application object itself.
    //launchOptions: A dictionary of options that may contain information about the reason the app was launched.It's an optional parameter (? indicates optional) and is assigned a default value of nil if not provided.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //Creates an instance of the Braze SDK (braze) using the provided configuration.
        let configuration = Braze.Configuration(
            apiKey: "73c9f921-d20f-4e7d-9253-e56c923ae69a",
            endpoint: "sondheim.braze.com"
        )
        
        configuration.triggerMinimumTimeInterval = 5
        let braze = Braze(configuration: configuration)
        
        //Stores the Braze instance in the static property AppDelegate.braze for future reference.
        AppDelegate.braze = braze
        
        
        //Register your application to support push notifications.
        application.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        
        //support for notifications with action buttons.
         center.setNotificationCategories(Braze.Notifications.categories)
        
        //This assigns the current object (self) as the delegate for the UNUserNotificationCenter. By doing so, this object will receive notifications about events related to the delivery and handling of notifications. The delegate must conform to the UNUserNotificationCenterDelegate protocol, which includes methods for handling the arrival of notifications and actions selected by the user.
         center.delegate = self
        
        //requests authorization to deliver notifications in the specified ways:
         center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
           print("Notification authorization, granted: \(granted), error: \(String(describing: error))")
         }
        
    
        //Initialize a BrazeInAppMessageUI object and set it on the Braze instance’s inAppMessagePresenter.
        let inAppMessageUI = BrazeInAppMessageUI()
        braze.inAppMessagePresenter = inAppMessageUI
       
        //Returns true to indicate that the app has finished launching successfully.
        return true
    }
    
    
    //pass the device token to Braze.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppDelegate.braze?.notifications.register(deviceToken: deviceToken)
    }
    
    
    
    func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable : Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        
        //The handleBackgroundNotification method of the Braze SDK is designed to process notifications relevant to Braze functionalities, such as analytics, user engagement, etc.
      if let braze = AppDelegate.braze, braze.notifications.handleBackgroundNotification(
        userInfo: userInfo,
        fetchCompletionHandler: completionHandler
      ) {
        return
      }
      completionHandler(.noData)
    }
    
    
    // The function's purpose is to process the user's response to a notification, allowing the app to perform appropriate actions based on that interaction.
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      if let braze = AppDelegate.braze, braze.notifications.handleUserNotification(
        response: response,
        withCompletionHandler: completionHandler
      ) {
        return
      }
      completionHandler()
    }
    
    
    
    //This enables support for receiving user-visible remote notifications while the app is running in the foreground.
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      if #available(iOS 14.0, *) {
        completionHandler([.list, .banner])
      } else {
        completionHandler(.alert)
      }
    }
}




//The @main attribute is an entry point for the application, indicating that this structure is the application itself.
@main

//This declares a structure named TorchieApp that conforms to the App protocol. In SwiftUI, the App protocol is used to define the structure of an application.
struct TorchieApp: App {
    
    //This property uses the @UIApplicationDelegateAdaptor attribute to associate an instance of the AppDelegate class with the TorchieApp. It specifies that AppDelegate is the delegate for managing the application's lifecycle events.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
    //The WindowGroup scene represents the main window of the application.
        WindowGroup {
            
        //Within the WindowGroup, the ContentView() is set as the root view of the main window. ContentView is presumably the main user interface of the app.
            ContentView()
        }
    }
}
