//
// Copyright © 2021-2024 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/Geodesic
// MIT license
//

import Foundation
import CoreLocation
import CXXGeographicLib

// For more information see https://en.wikipedia.org/wiki/Geodesics_on_an_ellipsoid

// The direct problem

extension CLLocationCoordinate2D {
	/// Returns the coordinate *B* at `azimuth` *α1* and `distance` *s12* from `self` *A*.
	/// - parameter azimuth: The azimuth *α1* at `self` *A* in degrees.
	/// - parameter distance: The distance *s12* in meters.
	/// - returns: The coordinate *B* at `azimuth` and `distance` from `self` *A*.
	public func coordinate(atAzimuth azimuth: Double, distance: Double) -> CLLocationCoordinate2D {
		coordinateAndForwardAzimuth(atAzimuth: azimuth, distance: distance).B
	}

	/// Returns the forward azimuth *α2* at `azimuth` *α1* and `distance` *s12* from `self` *A*.
	/// - parameter azimuth: The azimuth *α1* at `self` *A* in degrees.
	/// - parameter distance: The distance *s12* in meters.
	/// - returns: The forward azimuth *α2* in degrees.
	public func forwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> Double {
		coordinateAndForwardAzimuth(atAzimuth: azimuth, distance: distance).α2
	}

	/// Returns the coordinate *B* and azimuth *α2* at `azimuth` *α1* and `distance` *s12* from `self` *A*.
	/// - parameter azimuth: The azimuth *α1* at `self` *A* in degrees.
	/// - parameter distance: The distance *s12* in meters.
	/// - returns: A tuple containing the the coordinate *B* and forward azimuth *α2* in degrees at `azimuth` and `distance` from `self` *A*.
	public func coordinateAndForwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> (B: CLLocationCoordinate2D, α2: Double) {
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		var α2: GeographicLib.Math.real = 0
		_ = GeographicLib.Geodesic.WGS84().pointee.Direct(latitude, longitude, azimuth, distance, &lat, &long, &α2)
		return (CLLocationCoordinate2D(latitude: lat, longitude: long), α2)
	}
}

// The inverse problem

extension CLLocationCoordinate2D {
	/// Returns the distance *s12* between `self` *A* and `other` *B* in meters.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: The distance *s12* in meters.
	public func distanceTo(_ other: CLLocationCoordinate2D) -> Double {
		distanceAndCoursesTo(other).s12
	}

	/// Returns the azimuth *α1* between `self` *A* and `other` *B* in degrees.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: The initial true course *α1* in degrees.
	public func initialTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
		distanceAndCoursesTo(other).α1
	}

	/// Returns the azimuth *α2* between `self` *A* and `other` *B* in degrees.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: The final true course *α2* in degrees.
	public func finalTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
		distanceAndCoursesTo(other).α2
	}

	/// Returns the distance *s12* , the initial true course *α1*, and the final true course *α2* between `self` *A* and `other` *B*.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: A tuple containing the distance *s12* in meters, the initial true course *α1* in degrees, and the final true course *α2* in degrees.
	public func distanceAndCoursesTo(_ other: CLLocationCoordinate2D) -> (s12: Double, α1: Double, α2: Double) {
		var s12: GeographicLib.Math.real = 0
		var α1: GeographicLib.Math.real = 0
		var α2: GeographicLib.Math.real = 0
		_ = GeographicLib.Geodesic.WGS84().pointee.Inverse(latitude, longitude, other.latitude, other.longitude, &s12, &α1, &α2)
		return (s12, α1, α2)
	}
}

extension CLLocationCoordinate2D {
	/// Returns the coordinate *C* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
	/// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: The coordinate at `distance` *s13*.
	public func coordinate(atDistance distance: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		coordinateAndForwardAzimuth(atDistance: distance, alongGeodesicTo: other).C
	}

	/// Returns the coordinate *C* and azimuth *α3* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
	/// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: A tuple containing the the coordinate *C* and forward azimuth *α3* in degrees at `distance`.
	public func coordinateAndForwardAzimuth(atDistance distance: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> (C: CLLocationCoordinate2D, α3: Double) {
		let line = GeographicLib.Geodesic.WGS84().pointee.InverseLine(latitude, longitude, other.latitude, other.longitude)
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		var α3: GeographicLib.Math.real = 0
		_ = line.Position(distance, &lat, &long, &α3)
		return (CLLocationCoordinate2D(latitude: lat, longitude: long), α3)
	}

	/// Returns the coordinate *C* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
	/// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: The coordinate *C* at `fraction` of the distance *s13* to `other`.
	public func coordinate(atFractionOfDistance fraction: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		coordinateAndForwardAzimuth(atFractionOfDistance: fraction, alongGeodesicTo: other).C
	}

	/// Returns the coordinate *C* and azimuth *α3* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
	/// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: A tuple containing the the coordinate *C* and forward azimuth *α3* in degrees at `fraction` of the distance *s13* to `other`.
	public func coordinateAndForwardAzimuth(atFractionOfDistance fraction: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> (C: CLLocationCoordinate2D, α3: Double) {
		let line = GeographicLib.Geodesic.WGS84().pointee.InverseLine(latitude, longitude, other.latitude, other.longitude)
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		var α3: GeographicLib.Math.real = 0
		_ = line.Position(line.Distance() * fraction, &lat, &long, &α3)
		return (CLLocationCoordinate2D(latitude: lat, longitude: long), α3)
	}
}

extension CLLocationCoordinate2D {
	/// Returns the coordinates of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
	/// - parameter spacing: The desired waypoint spacing, in meters.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: An array of waypoint coordinates.
	public func waypoints(spacedAtDistance spacing: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
		waypointsAndForwardAzimuths(spacedAtDistance: spacing, alongGeodesicTo: other).map { $0.C }
	}

	/// Returns the coordinates and azimuths of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
	/// - parameter spacing: The desired waypoint spacing, in meters.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
	public func waypointsAndForwardAzimuths(spacedAtDistance spacing: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> [(C: CLLocationCoordinate2D, α3: Double)] {
		let line = GeographicLib.Geodesic.WGS84().pointee.InverseLine(latitude, longitude, other.latitude, other.longitude)
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		var α3: GeographicLib.Math.real = 0
		var results: [(CLLocationCoordinate2D, Double)] = []
		for distance in stride(from: 0, to: line.Distance(), by: spacing) {
			_ = line.Position(distance, &lat, &long, &α3)
			results.append((CLLocationCoordinate2D(latitude: lat, longitude: long), α3))
		}
		return results
	}

	/// Returns the coordinates of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
	/// - parameter count: The desired number of waypoints.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: An array of waypoint coordinates.
	public func waypoints(count: Int, alongGeodesicTo other: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
		waypointsAndForwardAzimuths(count: count, alongGeodesicTo: other).map { $0.C }
	}

	/// Returns the coordinates and azimuths of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
	/// - parameter count: The desired number of waypoints.
	/// - parameter other: The destination coordinate *B*.
	/// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
	public func waypointsAndForwardAzimuths(count: Int, alongGeodesicTo other: CLLocationCoordinate2D) -> [(C: CLLocationCoordinate2D, α3: Double)] {
		precondition(count > 0, "Waypoint count must be positive")
		let line = GeographicLib.Geodesic.WGS84().pointee.InverseLine(latitude, longitude, other.latitude, other.longitude)
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		var α3: GeographicLib.Math.real = 0
		var results: [(CLLocationCoordinate2D, Double)] = []
		let increment = line.Distance() / Double(count + 1)
		for distance in stride(from: increment, to: line.Distance(), by: increment) {
			_ = line.Position(distance, &lat, &long, &α3)
			results.append((CLLocationCoordinate2D(latitude: lat, longitude: long), α3))
		}
		return results
	}
}

extension CLLocationCoordinate2D {
	/// Returns the MGRS coordinates for `self` to the specified precision.
	/// - parameter precision: The desired precision relative to 100 km, ranging from `-1...11`
	/// - returns: The MGRS coordinates for `self`
	/// - seealso: https://en.wikipedia.org/wiki/Military_Grid_Reference_System
	///
	/// The `precision` values have the following meanings:
	///
	/// Precision | Meaning
	/// --- | ---
	/// `-1` |  Grid Zone only
	/// `0` | 100 km
	/// `1` | 10 km
	/// `2` | 1 km
	/// `3` | 100 m
	/// `4` | 10 m
	/// `5` | 1 m
	/// `6` | 1 dm
	/// `7` | 1 cm
	/// `8` | 1 mm
	/// `9` | 0.0001 m
	/// `10` | 0.00001 m
	/// `11` | 1 µm
	public func toMGRS(precision: Int = 2) -> String {
		var zone: Int32 = 0
		var northp: Bool = false
		var x: GeographicLib.Math.real = 0
		var y: GeographicLib.Math.real = 0
		GeographicLib.UTMUPS.Forward(latitude, longitude, &zone, &northp, &x, &y)
		var mgrs: std.string = ""
		GeographicLib.MGRS.Forward(zone, northp, x, y, latitude, Int32(precision), &mgrs)
		return String(mgrs)
	}

	/// Creates a location coordinate object with the specified MGRS coordinates.
	/// - parameter mgrs: The MGRS coordinates.
	public init(mgrs: String) {
		var zone: Int32 = 0
		var prec: Int32 = 0
		var northp: Bool = false
		var x: GeographicLib.Math.real = 0
		var y: GeographicLib.Math.real = 0
		GeographicLib.MGRS.Reverse(std.string(mgrs), &zone, &northp, &x, &y, &prec)
		var lat: GeographicLib.Math.real = 0
		var long: GeographicLib.Math.real = 0
		GeographicLib.UTMUPS.Reverse(zone, northp, x, y, &lat, &long)
		self.init(latitude: lat, longitude: long)
	}
}
