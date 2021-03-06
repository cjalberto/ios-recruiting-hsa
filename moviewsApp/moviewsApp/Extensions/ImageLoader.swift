//
//  ImageLoader.swift
//  moviewsApp
//
//  Created by carlos jaramillo on 8/31/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import Foundation
import Alamofire

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    
    /// obitiene la imagen de una URL , la guarda en cache
    ///
    /// - Parameters:
    ///   - path: direccion donde esta la imagen
    ///   - completion: respuesta del callBack
    func loadImage(path: String, completion: @escaping (Bool, UIImage?)->Void) {
        
        if let image = imageCache.object(forKey: path as NSString) {
            completion(true, image)
        } else {
            let url = path
            Alamofire.request(url).responseData { (response) in
                if response.error == nil{
                    if let data = response.data{
                        if let image = UIImage(data: data){
                            self.imageCache.setObject(image, forKey: path as NSString)
                            completion(true, image)
                        }
                        else{
                            completion(false , nil)
                        }
                    }
                }
                else{
                    print(response.error ?? "Error is nil")
                    completion(false, nil)
                }
            }
        }
    }
    
    
    /// para obtener imagen de la cache
    ///
    /// - Returns: resultado de la busqueda
    func getImageCache()->NSCache<NSString, UIImage>{
        return self.imageCache
    }
}

extension UIImageView {
    
    
    /// carga la imagen en el componente
    ///
    /// - Parameter path: direccion URL de la imagen
    func loadPicture(of path: String) {
        self.addIndicator()
        if let url = URL(string: path){
            if UIApplication.shared.canOpenURL(url){
                ImageLoader.shared.loadImage(path: path) {(success, image) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.removeIndicator()
                        if success {
                            self.image = image
                        }
                    })
                }
            }
        }
    }
    
    
    /// agrega un CustomIndicator en el componente mientras se agrega la imagen
    func addIndicator(){
        let indicator = CustomIndicator(frame: CGRect(x: self.frame.midX - 10, y: self.frame.midY - 10, width: 20, height: 20))
        self.addSubview(indicator)
    }
    
    
    /// elimina el CustomIndicator cuando ya esta la imagen 
    func removeIndicator(){
        for item in self.subviews{
            if item is CustomIndicator{
                item.removeFromSuperview()
            }
        }
    }
}
