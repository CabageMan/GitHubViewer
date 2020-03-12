import Foundation

public struct DateUtilities {
    private enum DateElement {
        case year(count: Int?)
        case month(count: Int?)
        case day(count: Int?)
        case hour(count: Int?)
        case minute(count: Int?)
        case second(count: Int?)
        
        var suffix: String? {
            switch self {
            case .year(let count):
                return createSuffixForElement(elementsCount: count, elementName: "year")
            case .month(let count):
                return createSuffixForElement(elementsCount: count, elementName: "month")
            case .day(let count):
                return createSuffixForElement(elementsCount: count, elementName: "day")
            case .hour(let count):
                return createSuffixForElement(elementsCount: count, elementName: "hour")
            case .minute(let count):
                return createSuffixForElement(elementsCount: count, elementName: "minute")
            case .second(let count):
                return createSuffixForElement(elementsCount: count, elementName: "second")
            }
        }
        
        func createSuffixForElement(elementsCount: Int?, elementName: String) -> String? {
            guard let count = elementsCount, count != 0 else { return nil }
            let suffix = "\(count) " + elementName
            return count > 1 ? suffix + "s" : suffix
        }
    }
  
  public static func agoFormat(_ date: Date) -> String? {
    let dateFormatter = DateComponentsFormatter()
    dateFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
    dateFormatter.allowedUnits = [.second, .minute, .year, .month, .day, .hour]
    dateFormatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.dropAll
    let rerult = dateFormatter.string(from: date, to: Date())
    return rerult
  }
  
  public static func postedDateFormat(fromDate: Date, toDate: Date) -> String {
    let calendar = Calendar.current
    let flags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
    let components: DateComponents = calendar.dateComponents(flags, from: fromDate, to: toDate)
    
    if let ago = DateElement.year(count: components.year).suffix { return ago }
    if let ago = DateElement.month(count: components.month).suffix { return ago }
    if let ago = DateElement.day(count: components.day).suffix { return ago }
    if let ago = DateElement.hour(count: components.hour).suffix { return ago }
    if let ago = DateElement.minute(count: components.hour).suffix { return ago }
    if let ago = DateElement.second(count: components.second).suffix { return ago }
    return "1 second"
  }
    
    // Old method
//    public static func postedDateFormat(fromDate: Date, toDate: Date) -> String {
//      let calendar = Calendar.current
//      let flags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
//      let components: DateComponents = calendar.dateComponents(flags, from: fromDate, to: toDate)
//
//      func checkCalendarComponent(_ component: Int?, _ suffix: String) -> String? {
//        guard let dateComponent = component, dateComponent != 0, dateComponent != 0 else { return nil }
//        return String(dateComponent) + suffix
//      }
//
//      if let ago = checkCalendarComponent(components.year, "y") { return ago }
//      if let ago = checkCalendarComponent(components.month, "mo") { return ago }
//      if let ago = checkCalendarComponent(components.day, "d") { return ago }
//      if let ago = checkCalendarComponent(components.hour, "h") { return ago }
//      if let ago = checkCalendarComponent(components.minute, "m") { return ago }
//      if let ago = checkCalendarComponent(components.second, "s") { return ago }
//      return "1s"
//    }
  
  fileprivate static let durationDateFormatter: DateFormatter = DateUtilities.mkDurationDateFormatter()
  fileprivate static func mkDurationDateFormatter() -> DateFormatter {
    let durationDateFormatter = DateFormatter()
    durationDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    durationDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm:ss", options: 0, locale: nil)
    
    return durationDateFormatter
  }
  
  static public func calendarDateString(_ date: Date) -> String {
    let dateFormater = DateFormatter()
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormater.dateFormat = "dd MM, yyyy"
    let result = dateFormater.string(from: date)
    return result
  }
  
  static public func getAppDateInstallation() -> Date? {
    do {
      let bundleRoot = Bundle.main.bundlePath // e.g. /var/mobile/Applications/<GUID>/<AppName>.app
      let manager = FileManager.default
      let attrs = try manager.attributesOfItem(atPath: bundleRoot)
      return attrs[FileAttributeKey.creationDate] as? Date
    } catch {
      return nil
    }
  }
}

extension Date {
    var timeAgo: String {
        return DateUtilities.postedDateFormat(fromDate: self, toDate: Date())
    }
    
    var timeTo: String {
        return DateUtilities.postedDateFormat(fromDate: Date(), toDate: self)
    }
}

//MARK: - ISO8601 converting
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

//MARK: - Start and End of Day
extension Date {
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        var components = calendar.dateComponents(unitFlags, from: self)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        return calendar.date(from: components)!
   }

    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
}

//MARK: - Year bounds
extension Int {
    func getBoundsOfYear() -> (start: Date, end: Date) {
        var startDateComponents = DateComponents()
        startDateComponents.day = 1
        startDateComponents.month = 1
        startDateComponents.year = self
        startDateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        let startDate: Date = Calendar.current.date(from: startDateComponents) ?? Date()
        
        var endDateComponents = DateComponents()
        if self != Calendar.current.component(.year, from: Date()) {
            endDateComponents.day = 31
            endDateComponents.month = 12
            endDateComponents.year = self
            endDateComponents.timeZone = TimeZone(secondsFromGMT: 0)
            let endDate: Date = Calendar.current.date(from: endDateComponents) ?? Date()
            return (startDate, endDate)
        }
        
        return (startDate, Date())
    }
}

