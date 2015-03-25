import Foundation

protocol MunicipalService {

    func sendSander()

    func sendSnowPlow() -> Result

}

enum Result {
    case Success
    case Failure(String)
}
