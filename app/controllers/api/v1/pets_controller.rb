class Api::V1::PetsController < ApplicationController
  before_action :set_pet, only: [ :show, :update, :destroy ]

  # GET /api/v1/pets
  def index
    @pets = Pet.all
    render json: @pets
  end

  # GET /api/v1/pets/:id
  def show
    render json: @pet
  end

  # POST /api/v1/pets
  def create
    begin
      pet_class = pet_params[:type]&.constantize || Pet
      @pet = pet_class.new(pet_params)

      if @pet.save
        render json: @pet, status: :created
      else
        render json: { errors: @pet.errors.full_messages }, status: :unprocessable_content
      end
    rescue NameError
      render json: { errors: [ "Invalid pet type: #{pet_params[:type]}" ] }, status: :unprocessable_content
    end
  end

  # PATCH/PUT /api/v1/pets/:id
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: { errors: @pet.errors.full_messages }, status: :unprocessable_content
    end
  end

  # DELETE /api/v1/pets/:id
  def destroy
    @pet.destroy
    head :no_content
  end

  # GET /api/v1/pets/statistics/outside_zone
  def outside_zone_statistics
    # Use in-memory cache for pet count data as per task requirements
    render json: StatisticsService.get_pets_outside_zone_stats
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end
end
