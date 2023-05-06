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
				Entry(peripheral: peripheral)
			}
			.refreshable {
				ble.refreshPeripheralList()
			}
		} content: {
			PeripheralDetails(peripheralSelected: $selectPeri, serviceSelected: $selectServ)
				.onAppear {
					selectServ = nil
				}
		} detail: {
			ServiceDetails(selectServ: $selectServ, peripheralSelected: $selectPeri)
		}
	}
}

struct Entry: View {
	let peripheral: Peripheral
	@EnvironmentObject var ble: Ble

	var body: some View {
		HStack {
			Text(peripheral.cbPeripheral.name!)
			Spacer()
			Button(ble.connectionStatus[peripheral] == .Disconnected ? "Connect" : "Disconnect", action: {
				if ble.connectionStatus[peripheral] == .Disconnected {
					ble.connectToPeripheral(peripheral: peripheral)
					return
				}
				ble.disconnectFromPeripheral(peripheral: peripheral)
			})
			.buttonStyle(MyButtonStyle())
			if ble.connectionStatus.contains(where: {$0.key == peripheral}) {
				switch ble.connectionStatus[peripheral] {
					case .Connected:
						Image(systemName: "antenna.radiowaves.left.and.right")
							.foregroundColor(.green)
					case .Aborted:
						Image(systemName: "wifi.exclamationmark")
							.foregroundColor(.red)
					default:
						Image(systemName: "antenna.radiowaves.left.and.right.slash")
							.foregroundColor(.white)
				}

			}
		}
	}
}
