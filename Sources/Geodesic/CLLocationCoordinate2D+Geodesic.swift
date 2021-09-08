//
// Copyright © 2021 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/Geodesic
// MIT license
//

import Foundation
import CoreLocation
import CGeodesic

extension CLLocationCoordinate2D {
	/// Returns the distance *s* between `self` and `other` in meters.
	/// - parameter other: The destination coordinate.
	/// - returns: The distance in meters.
	public func distanceTo(_ other: CLLocationCoordinate2D) -> Double {
		var s: Double = 0
		geod_inverse(&Self.wgs84, latitude, longitude, other.latitude, other.longitude, &s, nil, nil)
		return s
	}

	/// Returns the initial true course *α1* between `self` and `other` in degrees.
	/// - parameter other: The destination coordinate.
	/// - returns: The initial true course in degrees.
	public func initialTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
		var α1: Double = 0
		geod_inverse(&Self.wgs84, latitude, longitude, other.latitude, other.longitude, nil, &α1, nil)
		return α1
	}

	/// Returns the final true course *α2* between `self` and `other` in degrees.
	/// - parameter other: The destination coordinate.
	/// - returns: The final true course in degrees.
	public func finalTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
		var α2: Double = 0
		geod_inverse(&Self.wgs84, latitude, longitude, other.latitude, other.longitude, nil, nil, &α2)
		return α2
	}
}

extension CLLocationCoordinate2D {
	/// Returns the coordinate at `distance` along the geodesic from `self` to `other`.
	/// - parameter distance: The distance from `self` where the coordinate should be located, in meters.
	/// - parameter other: The ending coordinate.
	/// - returns: The  coordinate at `distance`.
	public func coordinate(atDistance distance: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		var α1: Double = 0
		geod_inverse(&Self.wgs84, latitude, longitude, other.latitude, other.longitude, nil, &α1, nil)

		var lat: Double = 0
		var long: Double = 0
		geod_direct(&Self.wgs84, latitude, longitude, α1, distance, &lat, &long, nil)

		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}

	/// Returns the coordinate at `fraction` of the distance on the geodesic from `self` to `other`.
	/// - parameter fraction: The fraction of the distance between `self` and `other` where the coordinate should be located.
	/// - parameter other: The ending coordinate.
	/// - returns: The  coordinate at `fraction` of the distance to `other`.
	public func coordinate(atFractionOfDistance fraction: Double, to other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		var s: Double = 0
		var α1: Double = 0
		geod_inverse(&Self.wgs84, latitude, longitude, other.latitude, other.longitude, &s, &α1, nil)

		var lat: Double = 0
		var long: Double = 0
		geod_direct(&Self.wgs84, latitude, longitude, α1, s * fraction, &lat, &long, nil)

		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}

extension CLLocationCoordinate2D {
	/// The WGS-84 ellipsoid.
	static var wgs84: geod_geodesic = {
		var g = geod_geodesic()
		geod_init(&g, 6378137, 1 / 298.257223563)
		return g
	}()
}
