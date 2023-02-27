//
//  ViewController.swift
//  PokemonGOAula
//
//  Created by Jamilton  Damasceno.
//  Copyright © Jamilton  Damasceno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var pokemons: [Pokemon] = []
    var coreDataPokemon: CoreDataPokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.coreDataPokemon = CoreDataPokemon()
        pokemons = coreDataPokemon.recuperarTodosPokemons()
        
            gerenciadorLocalizacao.delegate = self
            mapView.delegate = self
            gerenciadorLocalizacao.requestWhenInUseAuthorization()
            gerenciadorLocalizacao.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { (timer) in
                
                //espalhar os pokemons
                if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                    
                    let indice = UInt32(self.pokemons.count)
                    let pokemon = self.pokemons[ Int(arc4random_uniform(indice)) ]
                    
                    let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon )
                    //anotacao.coordinate = coordenadas
                    
                    let latAleatoria = (Double( arc4random_uniform(200) ) - 100.0) / 50000.0
                    let lonAleatoria = (Double( arc4random_uniform(200) ) - 100.0) / 50000.0
                    
                    anotacao.coordinate.latitude += latAleatoria
                    anotacao.coordinate.longitude += lonAleatoria
                    self.mapView.addAnnotation( anotacao )
                }
                
            })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacao = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacao.image = #imageLiteral(resourceName: "player")
        }else{
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            anotacao.image = UIImage(named: pokemon.nomeImagem! )
        }
        
        var frame = anotacao.frame
        frame.size.height = 40
        frame.size.width  = 40
        anotacao.frame = frame
        
        return anotacao
        
    }

    
    @IBAction func centralizar(_ sender: AnyObject) {
        centralizarLocal()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contador < 3 {
            centralizarLocal()
            contador += 1
        }else{
            //gerenciadorLocalizacao.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            let alertaController = UIAlertController(title: "Permissão de localização",
                                                     message: "Necessário permissão para acesso à sua localização!! por favor habilite.",
                                                     preferredStyle: .alert )
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default , handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString ) {
                    UIApplication.shared.open( configuracoes as URL )
                }
                
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default , handler: nil )
            
            alertaController.addAction( acaoConfiguracoes )
            alertaController.addAction( acaoCancelar )
            
            present( alertaController , animated: true, completion: nil )
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let coordenadas = anotacao?.coordinate
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
            return
        }
        
        let regiao = MKCoordinateRegion( center: coordenadas!, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(regiao, animated: true)
        
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon
        
            /*
             Verifica se um determinado ponto (MKMapPoint...), esta contido em uma area
             
            */
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                    if self.mapView.visibleMapRect.contains(MKMapPoint(coord)) {
                        print("Você pode capturar o Pokemon!!")
                        
                        let context = self.coreDataPokemon.getContext()
                        pokemon.capturado = true
                        
                        do{
                            try context.save()
                            self.mapView.removeAnnotation(view.annotation!)
                            
                            let alertaController = UIAlertController(title: "Parabéns!!",
                                                                     message: "Você capturou o \(pokemon.nome!) ",
                                preferredStyle: .alert )
                            
                            
                            let ok = UIAlertAction(title: "ok", style: .default , handler: nil )
                            alertaController.addAction( ok )
                            self.present( alertaController , animated: true, completion: nil )
                            
                        }catch{}
                        
                    }else{
                        
                        let alertaController = UIAlertController(title: "Você não pode Capturar",
                                                                 message: "Você precisa se aproximar mais para capturar o \(pokemon.nome!) ",
                                                                 preferredStyle: .alert )
                        
                        
                        let ok = UIAlertAction(title: "ok", style: .default , handler: nil )
                        alertaController.addAction( ok )
                        self.present( alertaController , animated: true, completion: nil )
                        
                    }
                }
            })
        
    }
    
    func centralizarLocal(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegion( center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(regiao, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

