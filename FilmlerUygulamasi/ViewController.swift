//
//  ViewController.swift
//  FilmlerUygulamasi
//
//  Created by Kasım Adalan on 30.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var kategoriTableView: UITableView!
    
    var kategorilerListe = [Kategoriler]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kategoriTableView.delegate = self
        kategoriTableView.dataSource = self
        tumKategoriler()
        
    }
    
    
    func tumKategoriler(){
        
        AF.request("http://kasimadalan.pe.hu/filmler/tum_kategoriler.php",method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(KategoriCevap.self, from: data)
                    if let kat = cevap.kategoriler {
                        self.kategorilerListe = kat
                    }
                    DispatchQueue.main.async {
                        self.kategoriTableView.reloadData()
                    }
                    
                } catch {
                    print("hata")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        var vc = segue.destination as! FilmViewController
        vc.kategori = kategorilerListe[indeks!]
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kategori = kategorilerListe[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kategoriHucre", for: indexPath) as! KategoriHucreTableViewCell
        
        cell.labelKategoriAd.text = kategori.kategori_ad
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toFilm", sender: indexPath.row)
    }
}
