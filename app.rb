require "sinatra/base"
require "dootywater/constants"

module DootyWater
  class WebApp < Sinatra::Base

    last_check = Time.now
    dooties = []

    get "/" do
      update_dooties
      dooties
    end

    helpers do
      def update_dooties
        curr_time = Time.now
        # periodically update the dooties array
        if curr_time - last_check > ::DootyWater::Constant::CHECK_INTERVAL
          dooties.clear
          data = `tail -n 25 #{DootyWater::Constant::DATA_DIR}/dooties.txt`
          dooties << data.split("\n")
          dooties.flatten!
        end
      end
    end
  end
end
