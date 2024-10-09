import Foundation

@propertyWrapper
struct FormattedDate {
    private var date: Date = Date()
    
    var wrappedValue: String {
        let formatter = DateFormatter()
        
        if Locale.current.languageCode == "ru" {
            formatter.locale = Locale(identifier: "ru_RU")
        }
        //formatter.locale = Locale(identifier: "ru_RU") // Локаль для русского языка
        formatter.dateFormat = "EEEE, d MMM." // Формат "Среда, 2 Окт."
        return formatter.string(from: date)
    }
}

struct FormattedDay {
    func format(with date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "ru_RU") // Локаль для русского языка
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
