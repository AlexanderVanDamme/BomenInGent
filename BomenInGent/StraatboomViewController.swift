import UIKit
import MapKit
import CoreLocation

class StraatboomViewController: UITableViewController {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var gekozenBoom: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var aantalStratenLabel: UILabel!
    
    @IBOutlet weak var dichtsteLabel: UILabel!
    
    var boomVoorkomen: StraatbomenViewController.BoomVoorkomen!
    
    var aangeradenBoom : AangeradenBoom!
    
    struct AangeradenBoom {
        var straat : String!
        var locatie : CLLocationCoordinate2D!
    }
    
    func berekenAangeradenBoom(){
        var locaties = [CLLocationCoordinate2D]()
        var afstanden = [CLLocationDistance]()
        
        for straat in boomVoorkomen.straatNamen {
            locaties.append(getLocatie(straatnaam: straat))
            }
        
        for locatie in locaties {
            afstanden.append(berekenAfstand(locatie: locatie))
        }
   
        
        let minAfstand = afstanden.sorted().first
        
        let index = afstanden.index(of: minAfstand! as CLLocationDistance)
        
        
        aangeradenBoom = AangeradenBoom(straat: boomVoorkomen.straatNamen[index!], locatie: locaties[index!])
    }
    
    func getLocatie(straatnaam : String) -> CLLocationCoordinate2D{
        let geoCoder = CLGeocoder()
        var coordinates : CLLocationCoordinate2D!
        
        geoCoder.geocodeAddressString(straatnaam + "Gent", completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error")
            }
            
            if let placemark = placemarks?.first {
                 coordinates =  placemark.location!.coordinate
            }
        })
    return coordinates
    }
    
    
    func berekenAfstand(locatie : CLLocationCoordinate2D) -> CLLocationDistance{
        
        let currentLoc:CLLocationCoordinate2D = (locationManager.location?.coordinate)!
        
        let van = CLLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
        let naar = CLLocation(latitude: locatie.latitude, longitude: locatie.longitude)
        
        
        return van.distance(from: naar)
        
    }
  
    
    
    override func viewDidLoad() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.startUpdatingLocation()
        
        }
        
        
        title = boomVoorkomen.boomNaam
        
        berekenAangeradenBoom()
        
        gekozenBoom.text = boomVoorkomen.boomNaam
        
        aantalStratenLabel.text = "Deze boom is in Gent te vinden in \(boomVoorkomen.straatNamen.count) straten"
        
        dichtsteLabel.text = "Deze boom is het dichtste bij jou te zien in straat \(aangeradenBoom.straat)"
        
        mapView.region = MKCoordinateRegion(center: aangeradenBoom.locatie, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let pin = MKPointAnnotation()
        pin.coordinate = aangeradenBoom.locatie
        mapView.addAnnotation(pin)
 
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
}
