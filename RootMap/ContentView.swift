//
//  ContentView.swift
//  RootMap
//
//  Created by Macbook on 3/25/22.
//

import SwiftUI
import MapKit
struct ContentView: View {
    var body: some View{
        mapView()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct mapView:UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return mapView.Coordinator()
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<mapView>) {
        print("Update")
    }

    func makeUIView(context: UIViewRepresentableContext<mapView>) -> MKMapView {
        let map = MKMapView()
        let sourceco:[[String:Any]] = [["Lat":9.9312, "Lon":76.2673, "CityName": "Kochi"],
                                       ["Lat":11.0168, "Lon":76.9558, "CityName": "Coimbatore"],
                                       ["Lat":9.9252, "Lon":78.1198, "CityName": "Madurai"],
                                       ["Lat":10.0889, "Lon":77.0595, "CityName": "Munnar"]]
        for i in 0..<sourceco.count{
            let sourceCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(sourceco[i]["Lat"] as! Double), longitude: CLLocationDegrees(sourceco[i]["Lon"] as! Double))
            let lat = i+1 < sourceco.count ? CLLocationDegrees(sourceco[i+1]["Lat"] as! Double) : CLLocationDegrees(sourceco[0]["Lat"] as! Double)
            let lon = i+1 < sourceco.count ? CLLocationDegrees(sourceco[i+1]["Lon"] as! Double) : CLLocationDegrees(sourceco[0]["Lon"] as! Double)
            let destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707), latitudinalMeters: 1000, longitudinalMeters: 1000)
            let sourcePin = MKPointAnnotation()//source point
            sourcePin.coordinate = sourceCoordinate
            sourcePin.title = sourceco[i]["CityName"] as? String
            map.addAnnotation(sourcePin)
            let destinationPin = MKPointAnnotation()//Destination point...
            destinationPin.coordinate = destinationCoordinates
            destinationPin.title = i+1 < sourceco.count ? sourceco[i+1]["CityName"] as? String : sourceco[0]["CityName"] as? String
            map.addAnnotation(destinationPin)
            map.region = region
            map.delegate = context.coordinator
            let req = MKDirections.Request()
            req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
            req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
            let directions = MKDirections(request: req)
            directions.calculate { direct, err in
                if err != nil{
                    print(err?.localizedDescription as Any)
                    return
                }
                let polyline  = direct?.routes.first?.polyline
                map.addOverlay(polyline!)
                map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
            }
        }
        return map
    }
    class Coordinator : NSObject,MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .orange
            render.lineWidth = 3
            return render
        }
    }
}
