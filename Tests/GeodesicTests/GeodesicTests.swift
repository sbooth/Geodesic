import XCTest
import CoreLocation
@testable import Geodesic

final class GeodesicTests: XCTestCase {
	func testDistance() {
		let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
		let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
		let distance = lax.distanceTo(jfk)
		XCTAssertEqual(distance, 3982961, accuracy: 1)
	}

	func testMidpoints() {
		let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
		let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
		let midpoint = lax.coordinate(atFractionOfDistance: 0.5, alongGeodesicTo: jfk)
		let waypoints = lax.waypoints(count: 1, alongGeodesicTo: jfk)
		XCTAssertEqual(waypoints.count, 1)
		XCTAssertEqual(midpoint.latitude, waypoints.first!.latitude, accuracy: 0.0001)
		XCTAssertEqual(midpoint.longitude, waypoints.first!.longitude, accuracy: 0.0001)
	}
}
