class Api::SalonsController < ApplicationController
    def index
        render json: Salon.all
    end
end
