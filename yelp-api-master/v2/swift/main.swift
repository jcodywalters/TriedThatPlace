//
//  main.swift
//  YelpAPISample
//

import Foundation

// Fill in your API keys here from
// https://www.yelp.com/developers/manage_api_keys
let client = YLPClient(consumerKey: "nvDZ4O2juA2Ji8wzgRvP6w",
                       consumerSecret: "yXyknBtsLal-nMAFW0DkeCtG1iE",
                       token: "yzi9wB8v68ta5GeqdXoxHh0EUiRQzDYW",
                       tokenSecret: "3nOuLpz7BHfAOhURMEuuDfle_8s")

// Create a dispatch group to wait for search results
let group = DispatchGroup()
group.enter()

// Search for 3 dinner restaurants
client.search(withLocation: "Seattle, WA",
                          currentLatLong: nil,
                          term: "breakfast",
                          limit: 3,
                          offset: 0,
                          sort: .bestMatched)
{ search, error in
  // When leaving this completion handler, notify that the search finished
  defer {
    group.leave()
  }

  // Check if we received a result; if not, there was an error
  guard let search = search else {
    print("Search errored: \(error)")
    return
  }

  guard let topBusiness = search.businesses.first else {
    print("No businesses found")
    return
  }

    
  print("Top business: \(topBusiness.name), id: \(topBusiness.identifier)")
}

// Wait for the search to complete
group.wait(timeout: DispatchTime.distantFuture)
