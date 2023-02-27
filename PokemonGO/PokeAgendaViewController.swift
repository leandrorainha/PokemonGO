//
//  PokedexViewController.swift
//  PokemonGOAula
//
//  Created by Jamilton  Damasceno.
//  Copyright © Jamilton  Damasceno. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataPokemon = CoreDataPokemon()
        pokemonsCapturados = coreDataPokemon.recuperarPokemonsCapturados(capturado: true)
        pokemonsNaoCapturados = coreDataPokemon.recuperarPokemonsCapturados(capturado: false)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return pokemonsCapturados.count
        }else{
            return pokemonsNaoCapturados.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonsCapturados[ indexPath.row ]
        }else{
            pokemon = pokemonsNaoCapturados[ indexPath.row ]
        }
        
        let celula = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        //let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return celula
    }
    
    @IBAction func voltarMapa(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
