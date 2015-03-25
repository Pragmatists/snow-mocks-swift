import Foundation

class SnowRescueService {

    let municipalService: MunicipalService
    let weatherForecastService: WeatherForecastService
    let pressService: PressService

    init(municipalService: MunicipalService, weatherForecastService: WeatherForecastService, pressService: PressService) {
        self.municipalService = municipalService
        self.weatherForecastService = weatherForecastService
        self.pressService = pressService
    }

    func checkForecastAndRescue() {
        if weatherForecastService.getTemperatureInCelcius() < 0 {
            municipalService.sendSander()
        }
        if weatherForecastService.getSnowFallHeightInMm() > 3 {
            var snowPlowWasSent = false
            while !snowPlowWasSent {
                snowPlowWasSent = sendSnowPlow()
            }
        }
        if weatherForecastService.getSnowFallHeightInMm() > 5 {
            municipalService.sendSnowPlow()
        }
        if weatherForecastService.getSnowFallHeightInMm() > 10 {
            municipalService.sendSnowPlow()
            if weatherForecastService.getTemperatureInCelcius() < -10 {
                pressService.sendWeatherAlert()
            }
        }
    }

    func sendSnowPlow() -> Bool {
        let snowPlowWasSent = municipalService.sendSnowPlow()
        switch snowPlowWasSent {
        case .Success: return true
        case .Failure: return false
        }
    }
}