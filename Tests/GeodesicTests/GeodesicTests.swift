//
// Copyright © 2021-2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/Geodesic
// MIT license
//

import Testing
import CoreLocation
@testable import Geodesic

@Test func testDistance() {
	let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
	let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
	let distance = lax.distanceTo(jfk)
	#expect(Swift.abs(distance - 3982961) < 0.5)
}

@Test func testMidpoints() {
	let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
	let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
	let midpoint = lax.coordinate(atFractionOfDistance: 0.5, alongGeodesicTo: jfk)
	let waypoints = lax.waypoints(count: 1, alongGeodesicTo: jfk)
	#expect(waypoints.count == 1)
	#expect(Swift.abs(midpoint.latitude - waypoints.first!.latitude) < 0.001)
	#expect(Swift.abs(midpoint.longitude - waypoints.first!.longitude) < 0.001)
}
