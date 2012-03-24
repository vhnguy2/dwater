require "sinatra/base"
require "dootywater/constants"

module DootyWater
  class WebApp < Sinatra::Base

    last_check = 0
    dooties = []

    get "/" do
      dooties = update_dooties(last_check, dooties)
      erb :index, :locals => { :dooties => dooties }
    end

    helpers do
      def update_dooties(last_check, dooties)
        curr_time = Time.now.to_i
        # periodically update the dooties array
        if curr_time - last_check > ::DootyWater::Constant::CHECK_INTERVAL
          dooties.clear
          data = `tail -n 25 #{DootyWater::Constant::DATA_DIR}/dooties.txt`
          dooties << data.split("\n")
          dooties.flatten!
          dooties.reverse!
          last_check = curr_time
        end
        dooties
      end
    end
  end
end
