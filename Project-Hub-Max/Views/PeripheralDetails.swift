//
//  PeripheralDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

struct MyPeripheralDetails: View {
	@State private var serviceSelected: CBService?
	@State private var perif: Peripheral? = nil
	@EnvironmentObject var ble: Ble

	var body: some View {
		let peripheral = ble.config.myPeripheral
		NavigationSplitView {
			Text("Services of " + peripheral.name)
			let services = ble.myServices as [CBService]
			List(services, id: \.self, selection: $serviceSelected) { service in
				Text(service.uuid.uuidString)
			}
		} detail: {
			ServiceDetails(selectServ: $serviceSelected, peripheralSelected: $perif)
		}
		.onAppear {
			serviceSelected = nil
		}
	}
}

struct PeripheralDetails: View {
	@Binding var peripheralSelected: Peripheral?
	@Binding var serviceSelected: CBService?
	@EnvironmentObject var ble: Ble

    var body: some View {
		if let peripheral = peripheralSelected {
			if ble.connectionStatus[peripheral] == .Connected {
				DisplayDetail(peripheral: peripheral, serviceSelected: $serviceSelected)
			} else if ble.connectionStatus[peripheral] == .Connecting {
				ProgressView()
				Text("Connecting...")
			} else {
				if ble.connectionStatus[peripheral] == .Aborted {
					Text("We got disconnected by the peripheral " + (peripheral.cbPeripheral.name ?? ""))
				}
				Button("Connect to peripheral \(peripheral.cbPeripheral.name!)", action: {
					ble.connectToPeripheral(peripheral: peripheral)
				})
			}
		} else {
			Text("Select a peripheral to continue")
		}
    }
}

fileprivate struct DisplayDetail: View {
	let peripheral: Peripheral
	@Binding var serviceSelected: CBService?
	@EnvironmentObject var ble: Ble

	var body: some View {
		Text("Services of " + peripheral.cbPeripheral.name!)
		Button("Disconnect", action: {
			ble.disconnectFromPeripheral(peripheral: peripheral)
		})
		if let services = peripheral.cbPeripheral.services {
			List(services, id: \.self, selection: $serviceSelected) { service in
				Text(service.uuid.uuidString)
			}
		}
	}
}

