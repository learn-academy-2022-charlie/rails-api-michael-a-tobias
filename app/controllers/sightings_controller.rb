class SightingsController < ApplicationController

    # GET
    def index
        sightings = Sighting.all
        render json: sightings
    end

    # GET
    def show
        sighting = Sighting.find(params[:id])
        render json: sighting
    end

    # POST
    def create
        sighting = Sighting.create(sighting_params)
        if sighting.valid? 
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    # PUT
    def update
        sighting = Sighting.find(params[:id])
        if sighting.update(sighting_params)
            render json: sighting
        else
            render json: sighting.errors
        end
    end
    
    # DELETE
    def destroy
        sighting = Sighting.find(params[:id])
        sightings = Sighting.all
        sighting.destroy
        render json: sightings
    end

    private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :date, :lat, :long)
    end

end
