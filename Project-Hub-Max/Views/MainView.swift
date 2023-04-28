//
//  MainView.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct MainView: View {
	@Binding var selectPeri: CFPeripheral?
	@Binding var selectServ: CFService?
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