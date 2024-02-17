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
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let abbreviations: [PriceAbbreviation] = [.init(value: pow(10, 9), suffix: "B"), .init(value: pow(10, 6), suffix: "M"), .init(value: pow(10, 3), suffix: "K")]
        
        var suffix = ""
        var simplifiedNumber = number
        
        if let abbreviation = abbreviations.first(where: { number >= $0.value }) {
            suffix = abbreviation.suffix
            simplifiedNumber = number / abbreviation.value
        }
        
        if let text = formatter.string(from: NSDecimalNumber(decimal: simplifiedNumber)) {
            return "$" + text + suffix
        }
        
        return ""
    }
    
    private struct PriceAbbreviation {
        let value: Decimal
        let suffix: String
    }
    
}
