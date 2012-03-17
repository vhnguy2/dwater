$LOAD_PATH.unshift File.dirname(__FILE__)

require "app"

run Rack::URLMap.new("/" => DootyWater::WebApp.new)
