import Cocoa
import XCTest

class SnowMocksTest: XCTestCase {

    var municipalService: MockMunicipalService!
    var weatherForecastService: MockWeatherForecastService!
    var pressService: MockPressService!
    var snowRescueService: SnowRescueService!

    override func setUp() {
        municipalService = MockMunicipalService()
        weatherForecastService = MockWeatherForecastService()
        pressService = MockPressService()
        snowRescueService =
                SnowRescueService(municipalService: municipalService, weatherForecastService: weatherForecastService, pressService: pressService)
    }

    func test_SendsASanderWhenTemperatureBelow0() {
        weatherForecastService.forecastedTemperature = -5

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.sanderWasSent)
    }

    func test_DoesNotSendASanderWhenTemperatureIs0OrMore() {
        weatherForecastService.forecastedTemperature = 0

        snowRescueService.checkForecastAndRescue()

        XCTAssertFalse(municipalService.sanderWasSent)
    }

    func test_SendsSnowplowWhenSnowFallHeightIs4mmOrMore() {
        weatherForecastService.snowFallHeight = 4

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.snowplowWasSent)
    }

    func test_DoesNotSendSnowplowWhenSnowFallHeightIs2mmOrLess() {
        weatherForecastService.snowFallHeight = 2

        snowRescueService.checkForecastAndRescue()

        XCTAssertFalse(municipalService.snowplowWasSent)
    }

    func test_SendsTwoSnowPlowsWhenSnowFallHeightIs6mmOrMore() {
        weatherForecastService.snowFallHeight = 6

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.snowplowWasSentTwice)
    }

    func test_SendsAnotherSnowPlowAfterFirstFailed() {
        snowFallIsEnoughToSendASnowPlow()
        municipalService.sendingSnowPlowFails(times: 1)

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.snowplowWasSentTwice)
    }

    func test_SendsSnowPlowsUntilSucceeded() {
        snowFallIsEnoughToSendASnowPlow()
        municipalService.sendingSnowPlowFails(times: 3)

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.snowplowWasSent(times: 4))
    }

    func test_Sends3Snowplows1SanderAndNotifiesPressWhenExtremeWeather() {
        weatherForecastService.forecastedTemperature = -11
        weatherForecastService.snowFallHeight = 11

        snowRescueService.checkForecastAndRescue()

        XCTAssertTrue(municipalService.snowplowWasSent(times: 3))
        XCTAssertTrue(municipalService.sanderWasSent)
        XCTAssertTrue(pressService.weatherAlertReceived)
    }

    private func snowFallIsEnoughToSendASnowPlow() {
        weatherForecastService.snowFallHeight = 4
    }

    class MockWeatherForecastService: WeatherForecastService {
        var forecastedTemperature = 0
        var snowFallHeight = 0

        func getTemperatureInCelcius() -> Int {
            return forecastedTemperature
        }

        func getSnowFallHeightInMm() -> Int {
            return snowFallHeight
        }

    }

    class MockMunicipalService: MunicipalService {
        private(set) var sanderWasSent = false
        private var snowplowSentCount = 0
        private var snowplowFailures = 0
        func sendingSnowPlowFails(#times: Int) {
            snowplowFailures = times
        }

        var snowplowWasSent: Bool {
            get {
                return snowplowSentCount > 0
            }
        }

        var snowplowWasSentTwice: Bool {
            get {
                return snowplowWasSent(times: 2)
            }
        }

        func snowplowWasSent(#times: Int) -> Bool {
            return snowplowSentCount == times
        }

        func sendSander() {
            sanderWasSent = true
        }

        func sendSnowPlow() -> Result {
            snowplowSentCount++
            if (snowplowSentCount <= snowplowFailures) {
                return Result.Failure("SnowPlow malfunction")
            }
            return Result.Success
        }
    }

    class MockPressService: PressService {

        var weatherAlertReceived = false

        func sendWeatherAlert() {
            weatherAlertReceived = true
        }

    }

}
