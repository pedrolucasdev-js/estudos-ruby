class Api::SalonsController < ApplicationController
    def index
        render json: Salon.all
    end

    # Get /salons/:id
    def show
        render json: Salon.find(params[:id])
    end
end
