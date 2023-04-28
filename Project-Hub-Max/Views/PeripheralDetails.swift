//
//  PeripheralDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct MyPeripheralDetails: View {
	@Binding var selectPeripheral: CFPeripheral?
	@Binding var serviceSelected: CFService?

	var body: some View {
		NavigationSplitView {
			PeripheralDetails(peripheralSelected: $selectPeripheral, serviceSelected: $serviceSelected)
		} detail: {
			ServiceDetails(selectServ: $serviceSelected)
		}
		.onAppear {
			serviceSelected = nil
		}
	}

}

struct PeripheralDetails: View {
	@Binding var peripheralSelected: CFPeripheral?
	@Binding var serviceSelected: CFService?
	@EnvironmentObject var ble: Ble
	
    var body: some View {
		if let peripheral = peripheralSelected {
			DisplayDetail(peripheral: peripheral, serviceSelected: $serviceSelected)
		} else {
			DisplayDetail(peripheral: ble.config.myPeripheral, serviceSelected: $serviceSelected)
		}
    }
}

fileprivate struct DisplayDetail: View {
	let peripheral: CFPeripheral
	@Binding var serviceSelected: CFService?

	var body: some View {
		Text("Services of " + peripheral.name)
		List(peripheral.services, id: \.self, selection: $serviceSelected) { service in
			NavigationLink(service.id.uuidString, value: service.id)
		}
	}
}

