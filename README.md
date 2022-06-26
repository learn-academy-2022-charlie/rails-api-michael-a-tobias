# README
This application is a student challenge. The following is the prompt along with user and developer stories. The student will make edits to this README to keep track of edits and additions.

## Notes before implementation:

File path: app/controllers/application_controller.rb
 
 > `skip_before_action :verify_authenticity_token`
 
 This code was added to assist with development. Allowing this code to ship could compromise app security.

## Notes to self:

I deleted views and helpers to prevent Ruby magic from looking for views.

```
	deleted:    app/helpers/animals_helper.rb
	deleted:    app/views/layouts/application.html.erb
	deleted:    app/views/layouts/mailer.html.erb
	deleted:    app/views/layouts/mailer.text.erb
```

> Currently working on getting the animals_controller to display all the sightings associated with and individual animal. Might need to look at the user stories again.

# The API Stories

The Forest Service is considering a proposal to place in conservancy a forest of virgin Douglas fir just outside of Portland, Oregon. Before they give the go-ahead, they need to do an environmental impact study. They've asked you to build an API the rangers can use to report wildlife sightings.

- [x] Story: As a developer I can create an animal model in the database. An animal has the following information: *common name*, *latin name*, *kingdom* (mammal, insect, etc.).

    - in rails console:

        ```
        $ rails generate resource Animals common_name:string latin_name:string kingdom:string
        ```

- [x] Story: As the consumer of the API I can **see all the animals** in the database.
    - Hint: Make a few animals using Rails Console

> File path: app/controllers/animals_controller.rb
```
def show
    animal = Animal.find(params[:id])
    render json: animal
end
```

- [x] Story: As the consumer of the API I can **update an animal** in the database.

> File path: app/controllers/animals_controller.rb
```
def update
    animal = Animal.find(params[:id])
    if animal.update(params.require(:animal).permit(:common_name, :latin_name, :kingdom))
        render json: animal
    else
        render json: animal.errors
    end
end
```

- [x] Story: As the consumer of the API I can **destroy an animal** in the database.

> File path: app/controllers/animals_controller.rb
```
def destroy
    animal = Animal.find(params[:id])
    animals = Animal.all
    animal.destroy
    render json: animals
end
```

- [x] Story: As the consumer of the API I can **create a new animal** in the database.

> File path: app/controllers/animals_controller.rb
```
def create
    animal = Animal.create(animal_params)
    if animal.valid? 
        render json: animal
    else
        render json: animal.errors
    end
end
```

- [x] Story: As the consumer of the API I can **create a sighting** of an animal with *date* (use the datetime datatype), a *latitude*, and a *longitude*.
    > Hint: An animal has_many sightings. (rails g resource Sighting animal_id:integer ...)

`$ rails g resource Sighting animal_id:integer date:datetime lat:decimal long:decimal`
    

    > Hint: Datetime is written in Rails as “year-month-day hr:min:sec" (“2022-01-28 05:40:30") using 24-hr time


- [x] Story: As the consumer of the API I can update an **animal sighting** in the database.

> File path: app/controllers/sightings_controller.rb
```
    def update
        sighting = Sighting.find(params[:id])
        if sighting.update(sighting_params)
            render json: sighting
        else
            render json: sighting.errors
        end
    end
```

- [x] Story: As the consumer of the API I can **destroy an animal sighting** in the database.

> File path: app/controllers/sightings_controller.rb
```
def destroy
        sighting = Sighting.find(params[:id])
        sightings = Sighting.all
        sighting.destroy
        render json: sightings
    end
```

- [x] Story: As the consumer of the API, when I view a specific animal, I *can also see* a list sightings of that animal.
    > Hint: Checkout the Ruby on Rails API docs on how to include associations.

> File path: app/models/sighting.rb
```
class Sighting < ApplicationRecord
    belongs_to :animal # foreign key - animal_id
end
```

> File path: app/models/animal.rb
```
class Animal < ApplicationRecord
    has_many :sightings
end
```

> File path: app/controllers/animals_controller.rb
```
def show
    animal = Animal.find(params[:id])
    render json: [animal, animal.sightings.all]
end
```

- [x] Story: As the consumer of the API, I can run a report to *list all sightings* during a given time period.
    > Hint: Your controller can look like this:
```
class SightingsController < ApplicationController
  def index
    sightings = Sighting.where(date: params[:start_date]..params[:end_date])
    render json: sightings
  end
end
```
> File path: config/routes.rb
```
Rails.application.routes.draw do
  resources :sightings
  resources :animals
  get 'sightings/:start_date/:end_date' => "sightings#index"
end
```

> File path: app/controllers/sightings_controller.rb
```
    def index
        sightings = Sighting.where(date: params[:start_date]..params[:end_date])
        render json: sightings
    end
    
    //----------//

        private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :date, :lat, :long, :start_date, :end_date)
    end
```

> Remember to add the start_date and end_date to what is permitted in your strong parameters method. In Postman, you will want to utilize the params section to get the correct data. Also see Routes with Params .

## Stretch Challenges
> Note: All of these stories should include the proper RSpec tests. Validations will require specs in spec/models, and the controller method will require specs in spec/requests.

- [ ] Story: As the consumer of the API, I want to see validation errors if a sighting doesn't include: latitude, longitude, or a date.

- [ ] Story: As the consumer of the API, I want to see validation errors if an animal doesn't include a common name, or a latin name.

- [ ] Story: As the consumer of the API, I want to see a validation error if the animals latin name matches exactly the common name.

- [ ] Story: As the consumer of the API, I want to see a validation error if the animals latin name or common name are not unique.

- [ ] Story: As the consumer, I want to see a status code of 422 when a post request can not be completed because of validation errors.
Check out Handling Errors in an API Application the Rails Way

## Super Stretch Challenge

- [ ] Story: As the consumer of the API, I can submit sighting data along with a new animal in a single API call.
    > Hint: Look into `accepts_nested_attributes_for`