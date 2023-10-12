//
// Copyright © 2021-2023 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/Geodesic
// MIT license
//

import Foundation
import CGeodesic

// For more information see https://en.wikipedia.org/wiki/Geodesics_on_an_ellipsoid


#if canImport(CoreLocation)

import CoreLocation
// The direct problem

extension LLPoint {
    /// Makes CLLocationCoordinate2D from output.
    var toCoreLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: LLPoint {
    /// Returns the coordinate *B* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: The coordinate *B* at `azimuth` and `distance` from `self` *A*.
    public func coordinate(atAzimuth azimuth: Double, distance: Double) -> CLLocationCoordinate2D {
        (self as LLPoint).coordinate(atAzimuth: azimuth, distance: distance).toCoreLocationCoordinate
    }

    /// Returns the forward azimuth *a2* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: The forward azimuth *a2* in degrees.
    public func forwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> Double {
        (self as LLPoint).forwardAzimuth(atAzimuth: azimuth, distance: distance)
    }

    /// Returns the coordinate *B* and azimuth *a2* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: A tuple containing the the coordinate *B* and forward azimuth *a2* in degrees at `azimuth` and `distance` from `self` *A*.
    public func coordinateAndForwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> (B: CLLocationCoordinate2D, a2: Double) {
        let result = (self as LLPoint).coordinateAndForwardAzimuth(atAzimuth: azimuth, distance: distance)
        return (B: result.B.asCoreLocation, a2: result.a2)
    }
}

// The inverse problem

extension CLLocationCoordinate2D {
    /// Returns the distance *s12* between `self` *A* and `other` *B* in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The distance *s12* in meters.
    public func distanceTo(_ other: CLLocationCoordinate2D) -> Double {
        (self as LLPoint).distanceTo(other)
    }

    /// Returns the azimuth *a1* between `self` *A* and `other` *B* in degrees.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The initial true course *a1* in degrees.
    public func initialTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
        (self as LLPoint).initialTrueCourseTo(other)
    }

    /// Returns the azimuth *a2* between `self` *A* and `other` *B* in degrees.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The final true course *a2* in degrees.
    public func finalTrueCourseTo(_ other: CLLocationCoordinate2D) -> Double {
        (self as LLPoint).finalTrueCourseTo(other)
    }

    /// Returns the distance *s12* , the initial true course *a1*, and the final true course *a2* between `self` *A* and `other` *B*.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the distance *s12* in meters, the initial true course *a1* in degrees, and the final true course *a2* in degrees.
    public func distanceAndCoursesTo(_ other: CLLocationCoordinate2D) -> (s12: Double, a1: Double, a2: Double) {
        (self as LLPoint).distanceAndCoursesTo(other)
    }
}

extension CLLocationCoordinate2D {
    /// Returns the coordinate *C* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The coordinate at `distance` *s13*.
    public func coordinate(atDistance distance: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        (self as LLPoint).coordinate(atDistance: distance, alongGeodesicTo: other).asCoreLocation
    }

    /// Returns the coordinate *C* and azimuth *a3* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the the coordinate *C* and forward azimuth *a3* in degrees at `distance`.
    public func coordinateAndForwardAzimuth(atDistance distance: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> (C: CLLocationCoordinate2D, a3: Double) {
        let result = (self as LLPoint).coordinateAndForwardAzimuth(atDistance: distance, alongGeodesicTo: other)
        return (result.C.asCoreLocation, result.a3)
    }

    /// Returns the coordinate *C* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The coordinate *C* at `fraction` of the distance *s13* to `other`.
    public func coordinate(atFractionOfDistance fraction: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        (self as LLPoint).coordinate(atFractionOfDistance: fraction, alongGeodesicTo: other).asCoreLocation
    }

    /// Returns the coordinate *C* and azimuth *a3* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the the coordinate *C* and forward azimuth *a3* in degrees at `fraction` of the distance *s13* to `other`.
    public func coordinateAndForwardAzimuth(atFractionOfDistance fraction: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> (C: CLLocationCoordinate2D, a3: Double) {
        let result = (self as LLPoint).coordinateAndForwardAzimuth(atFractionOfDistance: fraction, alongGeodesicTo: other)
        return (result.C.asCoreLocation, result.a3)
    }
}

extension CLLocationCoordinate2D {
    /// Returns the coordinates of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
    /// - parameter spacing: The desired waypoint spacing, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of waypoint coordinates.
    public func waypoints(spacedAtDistance spacing: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        (self as LLPoint).waypoints(spacedAtDistance: spacing, alongGeodesicTo: other).asCoreLocations
    }

    /// Returns the coordinates and azimuths of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
    /// - parameter spacing: The desired waypoint spacing, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
    public func waypointsAndForwardAzimuths(spacedAtDistance spacing: Double, alongGeodesicTo other: CLLocationCoordinate2D) -> [(C: CLLocationCoordinate2D, a3: Double)] {
        let results = (self as LLPoint).waypointsAndForwardAzimuths(spacedAtDistance: spacing, alongGeodesicTo: other)
        return results.map{($0.C.asCoreLocation, $0.a3)}
    }

    /// Returns the coordinates of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
    /// - parameter count: The desired number of waypoints.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of waypoint coordinates.
    public func waypoints(count: Int, alongGeodesicTo other: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        (self as LLPoint).waypoints(count: count, alongGeodesicTo: other).asCoreLocations
    }

    /// Returns the coordinates and azimuths of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
    /// - parameter count: The desired number of waypoints.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
    public func waypointsAndForwardAzimuths(count: Int, alongGeodesicTo other: CLLocationCoordinate2D) -> [(C: CLLocationCoordinate2D, a3: Double)] {
        let results = (self as LLPoint).waypointsAndForwardAzimuths(count: count, alongGeodesicTo: other)
        return results.map{($0.C.asCoreLocation, $0.a3)}
    }
}
#endif
