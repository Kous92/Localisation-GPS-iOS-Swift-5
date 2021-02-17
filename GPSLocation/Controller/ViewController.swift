//
//  ViewController.swift
//  GPSLocation
//
//  Created by Koussaïla Ben Mamar on 12/02/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var gpsActif = false
    
    @IBOutlet weak var labelLongitude: UILabel!
    @IBOutlet weak var labelLatitude: UILabel!
    @IBOutlet weak var labelSyncGPS: UILabel!
    @IBOutlet weak var labelAdresseGPS: UILabel!
    @IBOutlet weak var boutonGPS: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.requestWhenInUseAuthorization()
        labelLongitude.isHidden = true
        labelLatitude.isHidden = true
        labelAdresseGPS.isHidden = true
        labelSyncGPS.text = "Le GPS est désactivé."
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        
        let authorization = manager.authorizationStatus
        
        // Si l'accès au service de localisation est autorisé
        if authorization == .authorizedAlways || authorization == .authorizedWhenInUse {
            let x = Double(first.coordinate.longitude)
            let y = Double(first.coordinate.latitude)
            labelLongitude.isHidden = false
            labelLatitude.isHidden = false
            labelAdresseGPS.isHidden = false
            getAddress(from: first)
            
            // Pour ne pas trop encombrer l'écran, le format sera limité à 7 chiffres après la virgule
            labelLongitude.text = String(format: "Longitude (x) = %.7f", x)
            labelLatitude.text = String(format: "Latitude (y) = %.7f", y)
        }
    }
    
    // Géocodage inverse pour l'adresse physique depuis les coordonnées GPS
    func getAddress(from location: CLLocation) {
        let géocodeur = CLGeocoder()
        géocodeur.reverseGeocodeLocation(location) { [weak self] place, error in
            if let error = error {
                print("Le géocodage inverse de la position actuelle a échoué, adresse indisponible. (\(error))")
                self?.labelAdresseGPS.text = "Le géocodage inverse de la position actuelle a échoué, adresse indisponible."

            } else {
                if let placemarks = place, let placemark = placemarks.first {
                    self?.labelAdresseGPS.text = placemark.compactAddress
                } else {
                    self?.labelAdresseGPS.text = "Aucune adresse correspondante trouvée."
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        
        // Les mises à jour de la localisation GPS ne sont pas autorisées.
        if let error = error as? CLError, error.code == .denied {
            // On évite de boucler sans fin le callback `didFailWithError` (a échoué avec erreur).
            locationManager?.stopMonitoringSignificantLocationChanges()
            locationManager?.stopUpdatingLocation()
            labelSyncGPS.isHidden = false
            
            // Vérification par rapport à la permission de l'utilisateur
            switch manager.authorizationStatus {
                case .denied: // Option: Jamais
                    print("Accès refusé au service de localisation.")
                    
                    // On affiche une alerte
                    let alert = UIAlertController(title: "Erreur", message: "Vous avez refusé l'accès au service de localisation. Merci de l'autoriser en allant dans Réglages > Confidentialité > Service de localisation > GPSLocation.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                    labelSyncGPS.text = "Impossible de synchroniser la position GPS. L'accès au service de localisation est refusé. Merci de l'autoriser en allant dans Réglages > Confidentialité > Service de localisation."
                    
                case .restricted: // Restreint par le contrôle parental
                    print("Accès restreint au service de localisation par le contrôle parental.")
                    
                    // On affiche une alerte
                    let alert = UIAlertController(title: "Erreur", message: "L'accès au service de localisation est restreint par le contrôle parental.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                    labelSyncGPS.text = "Impossible de synchroniser la position GPS. L'accès au service de localisation est restreint par le contrôle parental."
                    
                default:
                    labelSyncGPS.text = "Impossible de synchroniser la position GPS."
            }
            return
        }
    }
    
    // Démarrer / Arrêter le GPS
    @IBAction func triggerGPSButton(_ sender: Any) {
        if !gpsActif {
            boutonGPS.setTitle("Arrêter le GPS", for: .normal)
            labelSyncGPS.text = "Synchronisation GPS en cours..."
            locationManager?.startUpdatingLocation()
            gpsActif = true
        } else {
            boutonGPS.setTitle("Démarrer le GPS", for: .normal)
            labelSyncGPS.text = "Le GPS est désactivé."
            locationManager?.stopUpdatingLocation()
            gpsActif = false
            labelLongitude.isHidden = true
            labelLatitude.isHidden = true
            labelAdresseGPS.isHidden = true
        }
    }
}


extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            // Rue
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            // Ville
            if let city = locality {
                result += ", \(city)"
            }
            
            // Pays
            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
