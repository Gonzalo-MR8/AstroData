//
//  Bundle+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/6/22.
//

import Foundation

enum VersionError: Error {
    case invalidBundleInfo
    case invalidResponse
}

extension Bundle {
    public static func string(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }

    public static func isUpdateAvailable() throws -> Bool {
        guard let currentVersion = self.string(for: "CFBundleShortVersionString"),
            let identifier = Bundle.main.bundleIdentifier,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }

        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }

        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version != currentVersion
        }

        throw VersionError.invalidResponse
    }
}
