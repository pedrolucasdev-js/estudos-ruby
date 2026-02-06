class Api::ServicesController < ApplicationController
    def index
        render json: Service.all
    end
end
