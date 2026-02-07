class Api::ServicesController < ApplicationController
    # GET /api/services
    def index
        render json: Service.all
    end

    # POST /api/services
    def create
        service = Service.new(service_params)
        if service.save
            render json: service, status: :created
        else
            render json: service.errors, status: :unprocessable_entity
        end
    end

    private 
    def service_params
        params.require(:service).permit(
            :salon_id,
            :name,
            :duration_minutes,
            :price
        )
    end
end
