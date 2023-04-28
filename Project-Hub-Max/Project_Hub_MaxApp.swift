//
//  Project_Hub_MaxApp.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

enum BleError: Error {
	case noMyPeripheral
}

@main
struct Project_Hub_MaxApp: App {
	@State private var myPeripheral: CFPeripheral?
	@ObservedObject var ble: Ble

	init() {
		let url = Bundle.main.url(forResource: "bleConfig", withExtension: "json")

		ble = Ble(from: url)
		myPeripheral = CFPeripheral(name: "", services: [])
	}

    var body: some Scene {
        WindowGroup {
			ContentView(myPeripheral: $myPeripheral)
				.environmentObject(ble)
        }
    }
}
