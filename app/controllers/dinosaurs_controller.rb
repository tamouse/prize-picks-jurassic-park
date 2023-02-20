class DinosaursController < ApplicationController
  before_action :set_cage
  before_action :set_dinosaur, only: %i[ show move update destroy ]

  def index
    @dinosaurs =
      if @cage.present?
        @cage.dinosaurs
      else
        Dinosaur.all
      end

    payload = {
      dinosaurs: @dinosaurs.map { render_dinosaur(_1, false) }
    }

    render json: payload
  end

  def show
    render json: render_dinosaur(@dinosaur)
  end

  def create
    species = Species.find create_params[:species_id]
    service = DinosaurCreateService.new(species: species, name: create_params[:name])
    if service.create
      render json: render_dinosaur(service.dinosaur), status: :created, location: service.dinosaur
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def move
    service = DinosaurUpdateService.new(
      dinosaur: @dinosaur,
      name: update_params[:name],
      alive: update_params[:alive],
      cage_id: update_params[:cage_id]
    )
    if service.update
      render json: render_dinosaur(service.dinosaur)
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def update
    service = DinosaurUpdateService.new(
      dinosaur: @dinosaur,
      name: update_params[:name],
      alive: update_params[:alive],
      cage_id: update_params[:cage_id]
    )
    if service.update
      render json: render_dinosaur(service.dinosaur)
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @dinosaur.destroy
      render status: :no_content
    else
      render json: @dinosaur.errors, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:dinosaur).permit(:name, :species_id).to_h.symbolize_keys
  end

  def move_params
    params.require(:dinosaur).permit(:cage_id)
  end

  def render_dinosaur(dinosaur, root = true)
    dinosaur.as_json(
      root: root,
      include: [
        cage: { include: :diet },
        species: { include: :diet },
        diet: {}
      ]
    )
  end

  def set_cage
    @cage = params[:cage_id] ? Cage.find(params[:cage_id]) : nil
  end

  def set_dinosaur
    @dinosaur =
      if @cage.present?
        @cage.dinosaurs.find(params[:id])
      else
        Dinosaur.find(params[:id])
      end
  end

  def update_params
    params.require(:dinosaur).permit(:name, :alive, :cage_id)
  end

end
