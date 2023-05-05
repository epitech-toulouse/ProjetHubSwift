//
//  ContentView.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			MainView()
				.tabItem {
					Label("Menu", systemImage: "list.dash")
				}
			MyPeripheralDetails()
				.tabItem {
					Label("My Services", systemImage: "person.crop.circle")
				}
			LogView()
				.tabItem {
					Label("Interract", systemImage: "square.and.pencil")
				}
		}
    }
}
