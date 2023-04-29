//
//  MainView.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

struct MainView: View {
	@State private var selectPeri: Peripheral?
	@State private var selectServ: CBService?
	@EnvironmentObject var ble: Ble

	var body: some View {
		NavigationSplitView {
			Text("Peripherals")
			List(ble.peripherals, id: \.self, selection: $selectPeri) { peripheral in
				NavigationLink(peripheral.cbPeripheral.name!, value: peripheral.cbPeripheral.name!)
			}
		} content: {
			PeripheralDetails(peripheralSelected: $selectPeri, serviceSelected: $selectServ)
				.onAppear {
					selectServ = nil
				}
		} detail: {
			ServiceDetails(selectServ: $selectServ)
		}
	}
}
