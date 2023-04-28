//
//  ServideDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct ServiceDetails: View {
	@Binding var selectServ: CFService?

    var body: some View {
		if let serv = selectServ {
			Text("Characteristics of " + serv.id.uuidString)
		} else {
			Text("Select a service")
		}
    }
}

struct ServideDetails_Previews: PreviewProvider {
	@State static private var select: CFService? = nil

    static var previews: some View {
        ServiceDetails(selectServ: $select)
    }
}
