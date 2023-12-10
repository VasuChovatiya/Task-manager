//
//  String+Extension.swift
//  Task-1
//
//  Created by Vasu Chovatiya on 30/11/23.
//

import Foundation
import UIKit
import MobileCoreServices

extension String {
    
    public func toInt() -> Int? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //https://mkyong.com/regular-expressions/how-to-validate-username-with-regular-expression/
    public var isValidUserName: Bool {
        let userNameRegEx = "^[a-zA-Z0-9]([._-](?![._-])|[a-zA-Z0-9]){5,16}[a-zA-Z0-9]$"//"^[0-9a-zA-Z\\_.]{7,18}$"
        let userNameTest = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
        return userNameTest.evaluate(with: self)
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func getDateWithFormateUsingMillisecond(formate: String, timezone: String) -> String {
        if let second = Double(self) {
            let date = Date(timeIntervalSince1970: (second / 1000.0))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    public func getDateWithFormate(formate: String, timezone: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: timezone)
        return formatter.date(from: self)!
    }
    
    func getDateString(dateStr: String, from: String, to: String) -> String {
        if dateStr.isEmpty {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = from
        let date = dateFormatter.date(from: dateStr)!
        dateFormatter.dateFormat = to
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    public func getFormatedChatDate() -> String {
        var finalDate = ""
        let todayDate = Date().getDateStringWithFormate("yyyy-MM-dd", timezone: TimeZone.current.abbreviation()!)
        let createddate = getDateString(dateStr: self, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy-MM-dd")
        if todayDate == createddate {
            finalDate = getDateString(dateStr: self, from: "yyyy-MM-dd HH:mm:ss", to: "hh:mm a")
        } else {
            finalDate = getDateString(dateStr: self, from: "yyyy-MM-dd HH:mm:ss", to: "dd MMM yyyy hh:mm a")
        }
        
        return finalDate
    }
    
    public func isValidStringDateFormate() -> Bool {
        if self == "0000-00-00 00:00:00" {
            return false
        }
        
        return true
    }
    
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif", "jpeg"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeExtraaValue(value: String) -> String {
        return String(value.filter { !" ( ) - ".contains($0) })
    }
    
    func encodedUrlComponentString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func encodedUrlQueryString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    // *------------*
    // Normal string to get Encode string
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    // Encoded string to get normal string
    func fromBase64() -> String? {
        guard let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    // *------------*
    
    func notificationName() -> Notification.Name {
        return Notification.Name(self)
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }
    
    func makeACall() {
        guard   isValid(regex: .phone),
                let url = URL(string: "tel://\(self.onlyDigits())"),
                UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}

extension Data {
    /// Data to Hexadecimal String
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

extension String {
    func isAudio() -> Bool {
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.lowercased() as CFString, nil)
        return UTTypeConformsTo((uti?.takeRetainedValue())!, kUTTypeAudio)
    }
    func isAudioMimeType() -> Bool {
        if let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeUnretainedValue() {
            let extUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)
            if let fileExtension = extUTI?.takeRetainedValue() as String? {
                return fileExtension.isAudio()
            }
        }
        return false
    }
}
extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
