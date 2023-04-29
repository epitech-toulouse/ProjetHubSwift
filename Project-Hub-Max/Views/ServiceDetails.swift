//
//  ServideDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

struct ServiceDetails: View {
	@Binding var selectServ: CBService?

    var body: some View {
		if let serv = selectServ, let characteristics = serv.characteristics {
			Text("Characteristics of \(serv.uuid.uuidString)")
			List(characteristics, id: \.self) { charac in
				Text(charac.uuid.uuidString)
			}
		} else {
			Text("Select a service")
		}
    }
}
