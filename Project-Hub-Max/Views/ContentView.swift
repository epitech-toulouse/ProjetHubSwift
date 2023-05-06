//
//  ContentView.swift
//  Project-Hub-Max
//

import SwiftUI

struct ContentView: View {

    var body: some View {
		TabView {
			MainView()
				.toolbarBackground(.visible, for: .tabBar)
				.tabItem {
					Label("Menu", systemImage: "list.dash")
				}
			MyPeripheralDetails()
				.toolbarBackground(.visible, for: .tabBar)
				.tabItem {
					Label("My Services", systemImage: "person.crop.circle")
				}
			LogView()
				.toolbarBackground(.visible, for: .tabBar)
				.tabItem {
					Label("Log", systemImage: "square.and.pencil")
				}
		}
    }
}
