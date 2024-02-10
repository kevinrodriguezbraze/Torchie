//
//  ContentView.swift
//  Torchie
//
//  Created by Kevin Rodriguez on 1/30/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    var body: some View {
        TabView {
            UserView()
                .tabItem {
                    Image(systemName: "person")
                    Text("User")
                }
            ContentCardsView()
                .tabItem {
                    Image(systemName: "platter.2.filled.ipad")
                    Text("Content Cards")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
  

    
}

#Preview {
   ContentView()
}
