# frozen_string_literal: true

# Might now want to expose all of these in an API ?
class CagesController < ApplicationController
  before_action :set_cage, only: %i[ show update power_down power_up destroy ]

  def index
    @cages = Cage.all

    payload = {
      cages: @cages.map { render_cage(_1, false)}
    }
    render json: payload
  end

  def show
    render json: render_cage(@cage)
  end

  def create
    # TODO: Replace this with an operation
    @cage = Cage.new(cage_params)

    if @cage.save
      render json: render_cage(@cage), status: :created, location: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  def update
    # TODO: Replace this with an operation
    if @cage.update(cage_params)
      render json: render_cage(@cage)
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  def power_down
    if @cage.power_down!
      render json: render_cage(@cage)
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  def power_up
    if @cage.power_up!
      render json: render_cage(@cage)
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: Replace this with an operation
    @cage.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cage
    @cage = Cage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cage_params
    params.require(:cage).permit(:number, :diet_id, :species_id, :power_status)
  end

  def render_cage(cage, root = true)
    cage.as_json(
      root: root,
      include: [
        dinosaurs: {
          include: [:species, :diet]
        },
        species: {},
        diet: {}
      ]
    )
  end
end
