//
//  LogKitClass+DataFile.swift
//  Logger
//

import Foundation

// MARK: - NumberType
/// An Enum to get custom type
/// used later to check if the value passed is a number
private enum NumberType {
    case int
    case double
    case float
    case none
}

// MARK: - Is a Number
/// IsNumber take a value and returns the type of the number
///  - Parameters:
///     - data: Any type of data
///  - Returns: a `NumberType`, which is `none` if the data isn't a number or the good type between `int`, `float` and `double`
private func isNumber(data: Any) -> NumberType {
    guard ((data as? Int) == nil) else {
        return .int
    }
    guard ((data as? Float) == nil) else {
        return .float
    }
    guard ((data as? Double) == nil) else {
        return .double
    }
    return .none
}

// MARK: - Extension About The Data File
extension LogKit {
    // MARK: - Write In Data File
    /// This function writes in the data file the content of the dictionary
    /// - Parameters:
    ///    - newData: The `dictionary`containing the data to write in the file
    private func writeInData(newData: [String : Any]) {
        do {
            try JSONSerialization.data(withJSONObject: newData)
                .write(to: self.dataFileURL)
        } catch {
            print(error)
        }
    }

    // MARK: - Get Data File Content
    /// This function is used to retreive the content of the data file
    ///  - Returns: A `dictionary` containing the JSON data if **succeed** or `nil` if **failed**
    public func getDataFileContent() -> [String : Any] {
        do {
            let data = try Data(contentsOf: self.dataFileURL)
            let dictionary: [String : Any] = try JSONSerialization.jsonObject(with: data) as! [String : Any]

            return dictionary
        } catch {
            print("Unable to open the data file, creating a new one")
            return [:]
        }
    }

    // MARK: - Handle Number On Data
    /// This function handle the different types of number, it adds the new value to the previous one
    /// - Parameters:
    ///  - key: A `String` which is the **key** in the json file and in the dictionary
    ///  - value: The Value which is obligatorily a `number`
    ///  - type: The `NumberType` which precise what is the type of the
    private func handleNumData(key: String, value: Any, type: NumberType) {
        var dictionary = self.getDataFileContent()
        var doubleValue: Double = 0

        guard dictionary.isEmpty == false else {
            self.writeInData(newData: [key : value])
            return
        }
        switch type {
            case .int:
                guard let numValue = value as? Int else {
                    self.error(message: "An error occured when adding data of supposed type 'Int'")
                    return
                }
                doubleValue = Double(numValue)
            case .double:
                guard let numValue = value as? Double else {
                    self.error(message: "An error occured when adding data of supposed type 'Double'")
                    return
                }
                doubleValue = Double(numValue)
            case .float:
                guard let numValue = value as? Float else {
                    self.error(message: "An error occured when adding data of supposed type 'Float'")
                    return
                }
                doubleValue = Double(numValue)
            default:
                return
        }
        let newValue = (dictionary[key] as? Double ?? 0) + doubleValue
        dictionary[key] = newValue
        self.writeInData(newData: dictionary)
    }

    // MARK: - Handle Other Types Of Data
    /// This function handles all the non-numbers data type
    /// - Parameters:
    ///  - key: A `String` which is the **key** in the json file and in the dictionary
    ///  - value: The Value which is obligatorily not a `number`
    private func handleOtherTypes(key: String, value: Any) {
        var dictionary = self.getDataFileContent()

        guard dictionary.isEmpty == false else {
            self.writeInData(newData: [key : value])
            return
        }
        dictionary[key] = String(describing: value)
        self.writeInData(newData: dictionary)
    }

    // MARK: - Log The Datas
    /// This function handles the logging to the data file
    /// - Parameters:
    ///  - key: A `String` which is the **key** in the json file and in the dictionary
    ///  - value: The Value which is `anything` you want
    public func logData(message: String, value: Any) {
        let log: String = "[\(self.dateFormatter.string(from: Date()))] ADDING TO DATA : \(message) ==> \(value)\n"
        let type = isNumber(data: value)

        self.logger.log("\(log)")
		self.isUpdating = true
        if type != .none {
            self.handleNumData(key: message, value: value, type: type)
            return
        }
		self.handleOtherTypes(key: message, value: value)
		self.isUpdating = false
    }

    // MARK: - Log The Datas
    /// This function handles the logging to the data file
    /// - Parameters:
    ///  - dataStr: A `String` which is a JSON list of datas received
    public func addDataFromStr(dataStr: String) {
        guard let data = dataStr.data(using: .utf8) else { return }
        do {
            let dict = try JSONSerialization.jsonObject(with: data) as! [String : Any]

			self.isUpdating = true
            for (keyDict, valueDict) in dict {
                self.logData(message: keyDict, value: valueDict)
            }
		} catch {
			self.logger.error("An error occured when creating the dictionnary in addDataFromStr")
			self.isUpdating = false
			return
		}
		self.isUpdating = false
    }
}
