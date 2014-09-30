require 'net/http'
require 'rest-client'
require 'json'

def latest_headlines()
  results = RestClient.get('http://api.nytimes.com/svc/news/v3/content/all/all/.json?limit=5&api-key=c7d7096abd824fc2020662e64e4f3da7:8:63391730')
  parsed_results = JSON.parse results
  articles_list = parsed_results["results"]
  
  articles_list.each do |article_hash|
    headline = article_hash["title"]
  puts headline
  end
end

SCHEDULER.every '20s', :first_in => 0 do |job|
  headlines = latest_headlines()
  send_event('news', { :headlines => headlines})
end
