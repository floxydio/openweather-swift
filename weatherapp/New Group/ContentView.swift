//
//  ContentView.swift
//  weatherapp
//
//  Created by Dio Rovelino on 26/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var cityManager = CityManager()
    @State var weather: ResponseBody?
    @State var city = [CityModelElement]()
    @State var isLoading = true
    @State private var selection = "KABUPATEN BOGOR"
    var body: some View {
        VStack {
            if isLoading == true {
                ProgressView()
            } else {
                if let weather = weather {
                    if city.isEmpty {
                       Text("Not Found")
                    } else {
                        Text("Find Your Cloud").bold().font(.headline).italic()
                        Picker("Select Your City", selection: $selection) {
                            ForEach(city, id:\.id) {
                                res in Text(res.name)
                            }
                        }
                    }
                    Spacer()
                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 350)
                                        } placeholder: {
                                            ProgressView()
                                        }.padding(.bottom, 20)
                    Text("Cuaca Saat Ini")
                    Text("\(weather.weather[0].main)").bold().font(.largeTitle).padding(.top,10)
                    Spacer()
                } else {
                    Text("Not Working")
                }
                Button(action: {
                    Task {
                        do {
                          let data = try await weatherManager.fetchDataWeather(city: "Depok")
                            weather = data
                        } catch {
                            print("ERROR")
                        }
                    }
                   
                }, label: {
                    HStack{
                       Image(systemName: "location")
                        Text("Get Your City")
                   }
                })
            }
        }.task {
            do {
              let data = try await weatherManager.fetchDataWeather(city: "Depok")
                weather = data
                let dataCity = try await cityManager.fetchCityByJawaBarat()
                city = dataCity
                isLoading = false
            } catch {
                print("ERROR + \(error)")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
