import Foundation
import UIKit
/**

Shortcut function for creating URLSessionDataTask.

*/
struct MoaHttp {
  static func createDataTask(_ url: String,
    onSuccess: @escaping (Data?, HTTPURLResponse)->(),
    onError: @escaping (Error?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    if let urlObject = URL(string: url) {
      return createDataTask(urlObject: urlObject, onSuccess: onSuccess, onError: onError)
    }
    
    // Error converting string to NSURL
    onError(MoaError.invalidUrlString, nil)
    return nil
  }
  
  private static func createDataTask(urlObject: URL,
    onSuccess: @escaping (Data?, HTTPURLResponse)->(),
    onError: @escaping (Error?, HTTPURLResponse?)->()) -> URLSessionDataTask? {
      
    return MoaHttpSession.session?.dataTask(with: urlObject) { (data, response, error) in
      
      if let httpResponse = response as? HTTPURLResponse {
        if error == nil {
          
          if let responseData = data{
            if let responseImgae = UIImage(data: responseData){
              if (responseImgae.size.width > 200 || responseImgae.size.height>200) {
                var size = CGSize.init()
                if (responseImgae.size.width>responseImgae.size.height) {
                  let ratio = 120/responseImgae.size.width
                  size = CGSize(width: floor(responseImgae.size.width * ratio), height: floor(responseImgae.size.height * ratio))
                }else {
                  let ratio = 120/responseImgae.size.height
                  size = CGSize(width: floor(responseImgae.size.width * ratio), height: floor(responseImgae.size.height * ratio))
                }
             
              UIGraphicsBeginImageContext(size)
              responseImgae.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
              let image = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              onSuccess(image?.pngData(),httpResponse)
              } else {
                onSuccess(data,httpResponse)
              }
              
            }
          }
          //          if let picture = UIImage(data: data ?? Data() , scale: 1) {
//          let imageData = picture.pngData()
//            onSuccess(imageData, httpResponse)
//          }else{
//            onSuccess(data,httpResponse)
//          }
        } else {
          onError(error, httpResponse)
        }
      } else {
        onError(error, nil)
      }
    }
  }
  func scaled(image:UIImage,scale: CGFloat) -> UIImage? {
    // size has to be integer, otherwise it could get white lines
    
    return image
  }
}
