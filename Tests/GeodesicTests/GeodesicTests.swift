import XCTest
import CoreLocation
@testable import Geodesic

final class GeodesicTests: XCTestCase {
	func testDistance() {
		let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
		let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
		let distance = lax.distanceTo(jfk)
		XCTAssert(Int(distance) == 3982961)
	}
}
