import Foundation

extension NumberFormatter {
    
    static func changePercentFormat(_ number: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let text = formatter.string(from: NSDecimalNumber(decimal: number)) {
            return text + "%"
        }
        
        return ""
    }
  
    static func priceFormat(_ number: Decimal) -> String {
        return abbreviationFormat(number, suffix: "$")
    }
    
    static func abbreviationFormat(_ number: Decimal, suffix: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let abbreviations: [Abbreviation] = [.init(value: pow(10, 9), postfix: "B"), .init(value: pow(10, 6), postfix: "M"), .init(value: pow(10, 3), postfix: "K")]
        
        var postfix = ""
        var simplifiedNumber = number
        
        if let abbreviation = abbreviations.first(where: { number >= $0.value }) {
            postfix = abbreviation.postfix
            simplifiedNumber = number / abbreviation.value
        }
        
        if let text = formatter.string(from: NSDecimalNumber(decimal: simplifiedNumber)) {
            return suffix + text + postfix
        }
        
        return ""
    }
    
    private struct Abbreviation {
        let value: Decimal
        let postfix: String
    }
    
}
