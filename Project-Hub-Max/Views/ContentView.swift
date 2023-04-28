//
//  ContentView.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct ContentView: View {
	@State private var selectPeri: CFPeripheral? = nil
	@State private var selectServ: CFService? = nil
	@Binding var myPeripheral: CFPeripheral?

    var body: some View {
		TabView {
			MainView(selectPeri: $selectPeri, selectServ: $selectServ)
				.tabItem {
					Label("Menu", systemImage: "list.dash")
				}
			MyPeripheralDetails(selectPeripheral: $myPeripheral, serviceSelected: $selectServ)
				.tabItem {
					Label("My Services", systemImage: "person.crop.circle")
				}
			Interract()
				.tabItem {
					Label("Interract", systemImage: "square.and.pencil")
				}
		}
    }
}
