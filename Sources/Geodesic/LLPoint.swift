// Platform-independent variant of the CLLocationCoordinate Extension

import Foundation
import CGeodesic
#if canImport(CoreLocation)
import CoreLocation
#endif

/// Stores WGS-84 geodesic info.
public struct Geodesic {
    static var wgs84: geod_geodesic = {
        var g = geod_geodesic()
        geod_init(&g, 6378137, 1 / 298.257223563)
        return g
    }()
    public static var useCompassAzimuths: Bool = false
}

extension Double {
    var asAzimuth: Double {
        Geodesic.useCompassAzimuths ? self.inCompassForm : self
    }
    /// Convert returned azimuths to [0-360) degree interval.
    var inCompassForm: Double {
        var deg = self
        while deg < 0 {
            deg += 360
        }
        return deg.truncatingRemainder(dividingBy: 360)
    }
}

/// Protocol suitable for geodesic work.
public protocol LLPoint {
    var latitude: Double {get}
    var longitude: Double {get}
}

/// Simple return type for LLPoint operations.
/// If transforming to a non-CLLocationCoordinate2D type, an extension is necessary.
public struct LatLonPoint: LLPoint {
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(from pt: any LLPoint) {
        self.latitude = pt.latitude
        self.longitude = pt.longitude
    }
    
    public var latitude: Double
    public var longitude: Double
    
    
}


#if canImport(CoreLocation)
public extension LLPoint {
    var asCoreLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

public extension [LatLonPoint] {
    var asCoreLocations: [CLLocationCoordinate2D] {
        self.map{$0.asCoreLocation}
    }
}
#endif

public extension LLPoint {
    
    // MARK: - Direct solutions.
    
    /// Returns the coordinate *B* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: The coordinate *B* at `azimuth` and `distance` from `self` *A*.
    func coordinate(atAzimuth azimuth: Double, distance: Double) -> LatLonPoint {
        var lat: Double = 0
        var long: Double = 0
        geod_direct(&Geodesic.wgs84, latitude, longitude, azimuth, distance, &lat, &long, nil)
        return LatLonPoint(latitude: lat, longitude: long)
    }

    /// Returns the forward azimuth *a2* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: The forward azimuth *a2* in degrees.
    func forwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> Double {
        var a2: Double = 0
        geod_direct(&Geodesic.wgs84, latitude, longitude, azimuth, distance, nil, nil, &a2)
        return a2.asAzimuth
    }

    /// Returns the coordinate *B* and azimuth *a2* at `azimuth` *a1* and `distance` *s12* from `self` *A*.
    /// - parameter azimuth: The azimuth *a1* at `self` *A* in degrees.
    /// - parameter distance: The distance *s12* in meters.
    /// - returns: A tuple containing the the coordinate *B* and forward azimuth *a2* in degrees at `azimuth` and `distance` from `self` *A*.
    func coordinateAndForwardAzimuth(atAzimuth azimuth: Double, distance: Double) -> (B: LatLonPoint, a2: Double) {
        var lat: Double = 0
        var long: Double = 0
        var a2: Double = 0
        geod_direct(&Geodesic.wgs84, latitude, longitude, azimuth, distance, &lat, &long, &a2)
        return (LatLonPoint(latitude: lat, longitude: long), a2.asAzimuth)
    }
    
    // MARK: - Inverse solutions.
    
    /// Returns the distance *s12* between `self` *A* and `other` *B* in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The distance *s12* in meters.
    func distanceTo(_ other: any LLPoint) -> Double {
        var s12: Double = 0
        geod_inverse(&Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, &s12, nil, nil)
        return s12
    }

    /// Returns the azimuth *a1* between `self` *A* and `other` *B* in degrees.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The initial true course *a1* in degrees.
    func initialTrueCourseTo(_ other: any LLPoint) -> Double {
        var a1: Double = 0
        geod_inverse(&Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, nil, &a1, nil)
        return a1.asAzimuth
    }

    /// Returns the azimuth *a2* between `self` *A* and `other` *B* in degrees.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The final true course *a2* in degrees.
    func finalTrueCourseTo(_ other: any LLPoint) -> Double {
        var a2: Double = 0
        geod_inverse(&Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, nil, nil, &a2)
        return a2.asAzimuth
    }

    /// Returns the distance *s12* , the initial true course *a1*, and the final true course *a2* between `self` *A* and `other` *B*.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the distance *s12* in meters, the initial true course *a1* in degrees, and the final true course *a2* in degrees.
    func distanceAndCoursesTo(_ other: any LLPoint) -> (s12: Double, a1: Double, a2: Double) {
        var s12: Double = 0
        var a1: Double = 0
        var a2: Double = 0
        geod_inverse(&Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, &s12, &a1, &a2)
        return (s12, a1.asAzimuth, a2.asAzimuth)
    }
    
    // MARK: - Coordinates along geodesics.
    
    /// Returns the coordinate *C* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The coordinate at `distance` *s13*.
    func coordinate(atDistance distance: Double, alongGeodesicTo other: any LLPoint) -> LatLonPoint {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        geod_position(&l, distance, &lat, &long, nil)
        return LatLonPoint(latitude: lat, longitude: long)
    }

    /// Returns the coordinate *C* and azimuth *a3* at `distance` *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter distance: The distance from `self` *A* where the coordinate should be located, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the the coordinate *C* and forward azimuth *a3* in degrees at `distance`.
    func coordinateAndForwardAzimuth(atDistance distance: Double, alongGeodesicTo other: any LLPoint) -> (C: LatLonPoint, a3: Double) {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var a3: Double = 0
        geod_position(&l, distance, &lat, &long, &a3)
        return (LatLonPoint(latitude: lat, longitude: long), a3.asAzimuth)
    }

    /// Returns the coordinate *C* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: The coordinate *C* at `fraction` of the distance *s13* to `other`.
    func coordinate(atFractionOfDistance fraction: Double, alongGeodesicTo other: any LLPoint) -> LatLonPoint {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        geod_position(&l, l.s13 * fraction, &lat, &long, nil)
        return LatLonPoint(latitude: lat, longitude: long)
    }

    /// Returns the coordinate *C* and azimuth *a3* at `fraction` of the distance *s13* along the geodesic from `self` *A* to `other` *B*.
    /// - parameter fraction: The fraction of the distance between `self` *A* and `other` *B* where the coordinate should be located.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: A tuple containing the the coordinate *C* and forward azimuth *a3* in degrees at `fraction` of the distance *s13* to `other`.
    func coordinateAndForwardAzimuth(atFractionOfDistance fraction: Double, alongGeodesicTo other: any LLPoint) -> (C: LatLonPoint, a3: Double) {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var a3: Double = 0
        geod_position(&l, l.s13 * fraction, &lat, &long, &a3)
        return (LatLonPoint(latitude: lat, longitude: long), a3.asAzimuth)
    }
    
    // MARK: - Waypoint creation
    
    /// Returns the coordinates of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
    /// - parameter spacing: The desired waypoint spacing, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of waypoint coordinates.
    func waypoints(spacedAtDistance spacing: Double, alongGeodesicTo other: any LLPoint) -> [LatLonPoint] {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var results: [LatLonPoint] = []
        for distance in stride(from: 0, to: l.s13, by: spacing) {
            geod_position(&l, distance, &lat, &long, nil)
            results.append(LatLonPoint(latitude: lat, longitude: long))
        }
        return results
    }

    /// Returns the coordinates and azimuths of waypoints spaced at `spacing` along the geodesic from `self` *A* to `other` *B*.
    /// - parameter spacing: The desired waypoint spacing, in meters.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
    func waypointsAndForwardAzimuths(spacedAtDistance spacing: Double, alongGeodesicTo other: any LLPoint) -> [(C: LatLonPoint, a3: Double)] {
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var a3: Double = 0
        var results: [(LatLonPoint, Double)] = []
        for distance in stride(from: 0, to: l.s13, by: spacing) {
            geod_position(&l, distance, &lat, &long, &a3)
            results.append((LatLonPoint(latitude: lat, longitude: long), a3.asAzimuth))
        }
        return results
    }

    /// Returns the coordinates of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
    /// - parameter count: The desired number of waypoints.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of waypoint coordinates.
    func waypoints(count: Int, alongGeodesicTo other: any LLPoint) -> [LatLonPoint] {
        precondition(count > 0, "Waypoint count must be positive")
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var a3: Double = 0
        var results: [LatLonPoint] = []
        let increment = l.s13 / Double(count + 1)
        for distance in stride(from: increment, to: l.s13, by: increment) {
            geod_position(&l, distance, &lat, &long, &a3)
            results.append(LatLonPoint(latitude: lat, longitude: long))
        }
        return results
    }

    /// Returns the coordinates and azimuths of `count` waypoints evenly spaced along the geodesic from `self` *A* to `other` *B*.
    /// - parameter count: The desired number of waypoints.
    /// - parameter other: The destination coordinate *B*.
    /// - returns: An array of tuples containing the the coordinate and forward azimuth of the waypoints.
    func waypointsAndForwardAzimuths(count: Int, alongGeodesicTo other: any LLPoint) -> [(C: LatLonPoint, a3: Double)] {
        precondition(count > 0, "Waypoint count must be positive")
        var l = geod_geodesicline()
        geod_inverseline(&l, &Geodesic.wgs84, latitude, longitude, other.latitude, other.longitude, 0)
        var lat: Double = 0
        var long: Double = 0
        var a3: Double = 0
        var results: [(LatLonPoint, Double)] = []
        let increment = l.s13 / Double(count + 1)
        for distance in stride(from: increment, to: l.s13, by: increment) {
            geod_position(&l, distance, &lat, &long, &a3)
            results.append((LatLonPoint(latitude: lat, longitude: long), a3.asAzimuth))
        }
        return results
    }
    
}




