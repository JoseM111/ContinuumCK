 import Foundation
 
 // MARK: _@My-Tools
/**©------------------------------------------------------------------------------©*/
@discardableResult func divT(_ str: String) -> String {
    let myStr = """
    |><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    |>                    \(str)
    |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    """
    print(myStr)
    return myStr
}

@discardableResult func logT<T>(str: String, obj_t: T) -> String {
    let myStr = """
    |>==================================================
    |> \(str) \(obj_t)
    |>==================================================
    """
    print(myStr)
    return myStr
}

// A genric closure, that prints 'Any' tye of object
var printf : (Any) -> Void = { arg in
    let myStr = """
    |>==================================================
    |> \(arg)
    |>==================================================
    """
    print(myStr)
}

// Given a value to round and a factor to round to,
// round the value to the nearest multiple of that factor.
func roundTo(_ value: Double, toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}

// A closure, that Squares² a number. NOTE--! Has typealias
typealias numInNumOut = (Double) -> Double
var imASquare: numInNumOut = { numero  in
    
    let result = numero * numero
    print("| \(numero)² = \(roundTo(result, toNearest: 0.25))")
    
    return result
}

/** A function that filters numbers divisible by 2 */
func filterDiv2(args: [Int]) {
    let oddNums: [Int] = (args).filter { $0 % 2 == 0 }
    // Needs logT<--?
    logT(str: "Numbers divisible by '2': ", obj_t: oddNums)
}

/** A function that filters numbers divisible by 3 */
func filterDiv3(args: [Int]) {
    let oddNums: [Int] = (args).filter { $0 % 3 == 0 }
    // needs logT<--?
    logT(str: "Numbers divisible by '3': ", obj_t: oddNums)
}

/** A function that outputs the current date as: [Month Day, Year]
 In --> String format, not a date object
 but requires a singleton instance of date to be created */
@discardableResult func fixDate() -> String {
    let formatter = DateFormatter()
    let currentDate = Date()
    formatter.dateStyle = .medium
    let result = formatter.string(from: currentDate)
    return result
}

// Returns current date formatted, once a date object is passed
func currentDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    // US English Locale (en_US)
    dateFormatter.locale = Locale(identifier: "en_US")
    let todaysDate = dateFormatter.string(from: date)
    print(todaysDate)
    
    return todaysDate
}

/** A function that only returns even numbers */
func evenNums(num1: Int, num2: Int) {
    let oddNums: [Int] = (num1 ... num2).filter { $0 % 2 == 0 }
    logT(str: "Even number", obj_t: oddNums)
}

/** A function that only returns odd numbers */
func oddNums(num1: Int, num2: Int) {
    let oddNums: [Int] = (num1 ... num2).filter { $0 % 3 == 0 }
    logT(str: "Odd number", obj_t: oddNums)
}

extension Date {
    
    /**
     Sets Formatting for out dates. Returns a String
     date.dateRightNow()// Apr 26, 2020<--Example
     ## Important Notes ##
     1. This extends a Date; so it is usable on all Date objects
     2. Currently Set to medium Date length
     */
    func dateRightNow() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
/**©------------------------------------------------------------------------------©*/
