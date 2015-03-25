import Cocoa
import XCTest

class SnowMocksTest: XCTestCase {

    override func setUp() {
    }

    func test_SendsASanderWhenTemperatureBelow0() {
    }

    class MockWeatherForecastService: WeatherForecastService {

        func getTemperatureInCelcius() -> Int {
            return 0
        }

        func getSnowFallHeightInMm() -> Int {
            return 0
        }

    }

    class MockMunicipalService: MunicipalService {
        private(set) var sanderWasSent = false

        func sendSander() {
        }

        func sendSnowPlow() -> Result {
            return Result.Success
        }
    }

    class MockPressService: PressService {

        func sendWeatherAlert() {
        }

    }

}
