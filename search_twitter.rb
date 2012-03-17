$LOAD_PATH.unshift File.dirname(__FILE__)

require "multi_json"
require "net/http"
require "dootywater/constants"

RESULTS = "results"
TEXT    = "text"
ID      = "id"

#last_id_seen = 180894816106840064
uri = URI('http://search.twitter.com/search.json')
last_id_seen = 0

loop do
  params = { :q => "dootywater", :result_type => "recent", :since_id => last_id_seen }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  results_arry = MultiJson.decode(res.body)[RESULTS]

  if results_arry.size > 0
    File.open("#{DootyWater::Constant::DATA_DIR}/dooties.txt", "a") do |f|
      results_arry.each do |tweet|
        f.write "#{tweet[TEXT]}\n"
        last_id_seen = [last_id_seen, tweet[ID]].max
        puts tweet[TEXT]
      end
    end
  end

  sleep 5
end
