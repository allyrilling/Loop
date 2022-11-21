//
//  MapView.swift
//  Loop
//
//  Created by Ally Rilling on 8/10/22.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let lineCoordinates: [CLLocationCoordinate2D]

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

    let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
    mapView.addOverlay(polyline)

      mapView.isUserInteractionEnabled = false
      
    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {
      print("updates")
      if (lineCoordinates.capacity > 0) {
          view.centerCoordinate = CLLocationCoordinate2D(latitude: lineCoordinates[lineCoordinates.capacity / 4].latitude, longitude: lineCoordinates[lineCoordinates.capacity / 4].longitude)
//          view.region = mkco` how to center?
      }
      let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
      view.addOverlay(polyline)
      
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
      renderer.strokeColor = UIColor.systemGreen
      renderer.lineWidth = 4
      return renderer
    }
    return MKOverlayRenderer()
  }
}
