# Localisation GPS (Core Location) iOS (Swift 5)

Dans les applis mobiles, utiliser les données de localisation GPS sont courantes pour faire fonctionner divers services. Cela peut pourtant aussi poser problème au niveau de la vie privée si la localisation est utilisée à de mauvaises fins (pour tracer l'utilisateur avec la localisation en tâche de fond, ...). Sur iOS, c'est le framework Core Location qui le permet.

```swift
import CoreLocation
```

**ATTENTION: Si vous exploitez les données GPS, vous devez explicitement mentionner que vous exploitez les coordonnées GPS de l'utilisateur et préciser pour quel cas d'utilisation. Ne tentez surtout pas d'espionner vos utilisateurs avec les fonctionnalités de Core Location et vos serveurs, Apple vérifie systématiquement vos soumissions à l'App Store et tout manquement aux règles de vie privée résultera de la suppression de votre appli de l'App Store et potentiellement une révocation de votre compte de l'Apple Developer Program. Cela peut aussi vous porter préjudice au sein de la CNIL par une amende pour violation du RGPD.** 

Ici, voici donc une mini-application iOS native qui va récupérer les coordonnées GPS de l'iPhone/iPad, et afficher l'adresse (approximative ou exacte) par le géocodage inverse, une fois l'accès autorisé.

Cette mini-application effectue cet appel réseau de 2 méthodes (1 ViewController dédié par méthode):
- Par la voie originelle d'Apple avec `URLSession`
- Par un framework tiers très utilisé: Alamofire avec `AF.request()`

Concernant l'application:
- Version de déploiement: **iOS 14.0**
- Version de Swift: **5.3**

Le code à disposition est donc un modèle pour le développement de ses propres applications pour exploiter le service de localisation GPS en temps réel.

## Important à savoir

Le code de l'application iOS est structurée de l'architecture (design pattern) la plus simple: MVC-N (Model View Controller - Network)

### Localisation

Pour gérer la localisation, il faut 2 choses:
- Se conformer au protocole `CLLocationManagerDelegate`
- Utiliser un gestionnaire de localisation de type `CLLocationManager`

Je vous laisse découvrir le reste dans le code source. Vous pourrez donc réutiliser le contenu dans vos propres applications.