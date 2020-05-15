import Foundation

enum PostError: LocalizedError {
    
    case ckError(Error)
    case noRecord
    case noPost
    
    var localizedDescription: String {
        switch self {
        case .ckError(let error):
            let myStr = "[ERROR] something went wrong:-->> cloudkit. Error: \(error)"
            printf(myStr)
            return myStr
            
        case .noRecord:
            let myStr = "No record was [NO-RECORD] :-->> cloudkit."
            printf(myStr)
            return myStr
            
        case .noPost:
            let myStr = "[NO-POST_FOUND] :-->> cloudkit."
            printf(myStr)
            return myStr
        }
    }
}
