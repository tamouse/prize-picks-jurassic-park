class DinosaursController < ApplicationController
  before_action :set_dinosaur, only: %i[ show update destroy ]

  def index
    @dinosaurs = Dinosaur.all

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
    @dinosaur.destroy
  end

  private

  def set_dinosaur
    @dinosaur = Dinosaur.find(params[:id])
  end

  def create_params
    params.require(:dinosaur).permit(:name, :species_id).to_h.symbolize_keys
  end

  def update_params
    params.require(:dinosaur).permit(:name, :alive, :cage_id)
  end

  def render_dinosaur(dinosaur, root = true)
    dinosaur.as_json(
      root: root,
      include: [
        cage: { include: :vore },
        species: { include: :vore },
        vore: {}
      ]
    )
  end

end
