//
//  Interract.swift
//  Project-Hub-Max
//

import SwiftUI

struct LogView: View {
	@EnvironmentObject var logger: LogKit
	@State private var isAlertShowing: Bool = false

	private func getLines(from str: String) -> [String] {
		return str.components(separatedBy: .newlines).reversed().filter({$0.isEmpty == false})
	}

	private func getTextColor(using line: String) -> Color {
		if line.contains("`INFO`") {
			return .accentColor
		}
		if line.contains("`LOG`") {
			return .white
		}
		if line.contains("`ERROR`") {
			return .red
		}
		return .white
	}

    var body: some View {
		if logger.isUpdating == false {
			List(getLines(from: logger.getLogFileContent()), id: \.self, rowContent: { line in
				Text(line)
					.foregroundColor(getTextColor(using: line))
			})
			.alert("Would you like to clear the log file", isPresented: $isAlertShowing) {
				Button("Yes", role: .destructive, action: {
					logger.deleteFile(at: logger.logFileURL)
				})
				Button("No", role: .cancel, action: {})
			}
			.onTapGesture(count: 3, perform: {
				isAlertShowing.toggle()
			})
		}
    }
}
