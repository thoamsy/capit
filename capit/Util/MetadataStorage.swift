//
//  MetadataStorage.swift
//  capit
//
//  Created by yangkui on 2020/1/14.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import Foundation
import LinkPresentation

struct MetadataStorage {
    static func store(_ metadata: LPLinkMetadata) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            var metadatas = UserDefaults.standard.dictionary(forKey: "metadata") as? [String: Data] ?? [String: Data]()
            while metadatas.count > 10 {
                metadatas.removeValue(forKey: metadatas.randomElement()!.key)
            }
            metadatas[metadata.originalURL!.absoluteString] = data
            UserDefaults.standard.set(metadatas, forKey: "metadata")
        } catch {
            print("Fuck something: \(error)")
        }
    }
    
    static func metadata(for url: URL) -> LPLinkMetadata? {
        guard let metadatas = UserDefaults.standard.dictionary(forKey: "metadata") as? [String: Data] else {
            return nil
        }
        
        guard let data = metadatas[url.absoluteString] else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data)
        } catch {
            print("Failed")
            return nil
        }
    }
}
