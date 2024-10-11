//
// Copyright © 2021-2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/Geodesic
// MIT license
//

import Testing
import CoreLocation
@testable import Geodesic

let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)

@Test func testDistance() {
	let distance = lax.distanceTo(jfk)
	#expect(Swift.abs(distance - 3982961) < 0.5)
}

@Test func testMidpoints() {
	let midpoint = lax.coordinate(atFractionOfDistance: 0.5, alongGeodesicTo: jfk)
	let waypoints = lax.waypoints(count: 1, alongGeodesicTo: jfk)
	#expect(waypoints.count == 1)
	#expect(Swift.abs(midpoint.latitude - waypoints.first!.latitude) < 0.001)
	#expect(Swift.abs(midpoint.longitude - waypoints.first!.longitude) < 0.001)
}

@Test func testMGRS() {
	let mgrs = lax.mgrs(precision: 3)
	#expect(mgrs == "11SLT698566")
	let coord = CLLocationCoordinate2D(mgrs: mgrs)
	#expect(Swift.abs(coord.latitude - lax.latitude) < 0.001)
	#expect(Swift.abs(coord.longitude - lax.longitude) < 0.001)
}
