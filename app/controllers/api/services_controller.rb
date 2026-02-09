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

    # Delete /api/services/:id
    # se usa destroy ao inves de delete para seguir a convenção RESTful do Rails
    def destroy
        service = Service.find(params[:id])
        service.destroy
        head :no_content 
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
