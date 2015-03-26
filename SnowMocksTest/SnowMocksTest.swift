import Cocoa
import XCTest

class SnowMocksTest: XCTestCase {
    let weatherForecastService = MockWeatherForecastService()
    let municipalService = MockMunicipalService()
    var snowRescueService: SnowRescueService!

    override func setUp() {
        self.snowRescueService = SnowRescueService(weatherForecastService: weatherForecastService,
                municipalService: municipalService)
    }

    func test_SendsASanderWhenTemperatureBelow0() {
        weatherForecastService.temperature = -1

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.sanderWasSent)
    }

    class MockWeatherForecastService: WeatherForecastService {

        var temperature = 0
        func getTemperatureInCelcius() -> Int {
            return temperature
        }

        func getSnowFallHeightInMm() -> Int {
            return 0
        }

    }

    class MockMunicipalService: MunicipalService {
        private(set) var sanderWasSent = false

        func sendSander() {
            sanderWasSent = true
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
