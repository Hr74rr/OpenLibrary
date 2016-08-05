//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Daniel García Morales on 31/7/16.
//  Copyright © 2016 Daniel García Morales. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    
    @IBAction func limpiarTxt(sender: AnyObject) {
        txtISBN.text = ""
    }
    
    @IBAction func buscarISBN(sender: AnyObject) {
        
        self.titulo.text = ""
        self.autor.text = ""
        
        let url = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let urls = "\(url)\(self.txtISBN.text!)"
        let urlista = NSURL(string: urls)
        
        if let datos = NSData(contentsOfURL: urlista!){
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
                if json.count>0{
                    let response = json as! NSDictionary
                    let libro = response["ISBN:"+self.txtISBN.text!] as! NSDictionary
                    let nombre = libro["title"] as! NSString as String
                    self.titulo.text = nombre
                    
                    
                    let autores = libro["authors"] as! NSArray
                    for item in autores{
                        
                        self.autor.text = self.autor.text! + (item["name"] as! NSString as String)
                        
                        if let imagen = libro["cover"] as? NSDictionary{
                            dispatch_async(dispatch_get_main_queue(), {
                                let url = NSURL(string: imagen["large"] as! String)
                                let data = NSData(contentsOfURL: url!)
                                self.portada.image = UIImage(data: data!)
                            })
                        }
                        
                    }
                }else{
                    let alertController = UIAlertController(title: "OpenLibrary Request", message:
                        "El ISBN no se encuentra en la bd.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
            }catch _{
            }
        }else{
            let alertController = UIAlertController(title: "OpenLibrary Request", message:
                "Error en la conexion de internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

