class SightingsController < ApplicationController

    def index
        sightings = Sighting.all
        render json: sightings
    end

    def show
        sighting = Sighting.find(params[:id])
        render json: sighting
    end

    def create
        sighting = Sighting.create(animal_params)
        if sighting.valid? 
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    def update
        sighting = Sighting.find(params[:id])
        if sighting.update(params.require(:sighting).permit(:common_name, :latin_name, :kingdom))
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    def destroy
        sighting = Sighting.find(params[:id])
        sightings = Sighting.all
        sighting.destroy
        render json: sightings
    end

    private
    def animal_params
        params.require(:sighting).permit(:animal_id, :date, :lat, :long)
    end

end
