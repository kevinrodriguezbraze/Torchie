//
//  ContentView.swift
//  Torchie
//
//  Created by Kevin Rodriguez on 1/30/24.
//

import SwiftUI
import UIKit

struct ContentView: View {

    //VARIABLES
    
    @State private var externalID = ""
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var date = Date.now
    
    @State private var customAttributeKey = ""
    @State private var customAttributeValue = ""
    
    @State private var customEventName = ""
    @State private var customEventPropKey = ""
    @State private var customEventPropValue = ""
    
    @State private var productID = ""
    @State private var currency = "USD"
    @State private var price = 0.0
    @State private var quantity = 1
    @State private var purchaseEventPropKey = ""
    @State private var purchaseEventPropValue = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Change User") {
                    HStack {
                        TextField("External ID", text: $externalID)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.changeUser(userId: externalID)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            externalID = ""
                        })
                        
                    }
                    
                }
                
                Section("Main Attributes") {
                    HStack {
                        TextField("First Name", text: $firstName)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.user.set(firstName: firstName)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            firstName = ""
                        })
                    }
                    
                    HStack {
                        TextField("Last Name", text: $lastName)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.user.set(lastName: lastName)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            lastName = ""
                        })
                    }
                    
                    
                    
                    HStack {
                        TextField("Email Address", text: $email)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.user.set(email: email)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            email = ""
                        })
                    }
                    
                    
                    HStack {
                        TextField("Phone Number", text: $phoneNumber)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.user.set(phoneNumber: phoneNumber)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            phoneNumber = ""
                        })
                    }
                    
                    
                    HStack {
                        DatePicker("Date of Birth", selection: $date, displayedComponents: .date)
                        
                        Button("Set", action: {
                            AppDelegate.braze?.user.set(dateOfBirth: date)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        })
                        
                    }
                }
                
                Section("Custom Attributes") {
                    HStack {
                        TextField("Key", text: $customAttributeKey)
                        TextField("Value", text: $customAttributeValue)
                        Button("Set", action: {
                            AppDelegate.braze?.user.setCustomAttribute(key: customAttributeKey, value: customAttributeValue)
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            customAttributeKey = ""
                            customAttributeValue = ""
                        })
                    }
                }
                
                Section("Custom Events") {
                    HStack {
                        TextField("Event Name", text: $customEventName)
                        
                        Button("Log", action: logCustomEvent)
                    }
                    
                    HStack {
                        TextField("Key", text: $customEventPropKey)
                        TextField("Value", text: $customEventPropValue)
                    }
                }
                
                Section("Purchase Events") {
                    HStack {
                        TextField("Product ID", text: $productID)
                        
                        Button("Log", action: logPurchaseEvent)
                    }
                    TextField("Price", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? currency))
                        .keyboardType(.decimalPad)
                    Stepper("\(quantity)", value: $quantity, in: 1...25)
                    HStack {
                        TextField("Key", text: $purchaseEventPropKey)
                        TextField("Value", text: $purchaseEventPropValue)
                    }
                }
                
            }
            .navigationTitle("Torchie App")
        }
    }
    
    //FUNCTIONS
    func logCustomEvent() {
        if customEventPropKey == "" && customEventPropValue == "" {
            AppDelegate.braze?.logCustomEvent(name: customEventName)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            customEventName = ""
        } else {
            AppDelegate.braze?.logCustomEvent(name: customEventName, properties: [customEventPropKey: customEventPropValue])
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            customEventName = ""
            customEventPropKey = ""
            customEventPropValue = ""
        }
        showAlert = true
    }
    
    func logPurchaseEvent() {
        if purchaseEventPropKey == "" && purchaseEventPropValue == "" {
            AppDelegate.braze?.logPurchase (productId: productID, currency: currency, price: price, quantity: quantity)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            productID = ""
            price = 0.0
            quantity = 1
        } else {
            AppDelegate.braze?.logPurchase (productId: productID, currency: currency, price: price, quantity: quantity, properties: [purchaseEventPropKey : purchaseEventPropValue])
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            productID = ""
            price = 0.0
            quantity = 1
            purchaseEventPropKey = ""
            purchaseEventPropValue = ""
        }
        showAlert = true
    }
    

    
}

#Preview {
    ContentView()
}
