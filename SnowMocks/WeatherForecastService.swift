import Foundation

protocol WeatherForecastService {

    func getTemperatureInCelcius() -> Int

    func getSnowFallHeightInMm() -> Int
}