import Foundation

class SnowRescueService {

    private let municipalService: MunicipalService

    init(weatherForecastService: WeatherForecastService, municipalService: MunicipalService) {
        self.municipalService = municipalService
    }

    func checkForecastAndRescue() {
        municipalService.sendSander()
    }

}