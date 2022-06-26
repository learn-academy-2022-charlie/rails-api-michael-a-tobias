class AnimalsController < ApplicationController

    # GET
    def index
        animals = Animal.all
        render json: animals
    end

    # GET
    def show
        animal = Animal.find(params[:id])
        render json: [animal, animal.sightings.all] # .sightings.all shows all sightings associated with the particular id
    end

    # POST
    def create
        animal = Animal.create(animal_params)
        if animal.valid? 
            render json: animal
        else
            render json: animal.errors
        end
    end

    # PUT
    def update
        animal = Animal.find(params[:id])
        if animal.update(animal_params)
            render json: animal
        else
            render json: animal.errors
        end
    end

    # DELETE
    def destroy
        animal = Animal.find(params[:id])
        animals = Animal.all
        animal.destroy
        render json: animals
    end

    private
    def animal_params
        params.require(:animal).permit(:common_name, :latin_name, :kingdom)
    end

end
