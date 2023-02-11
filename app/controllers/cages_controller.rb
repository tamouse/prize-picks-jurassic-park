# frozen_string_literal: true

# Might now want to expose all of these in an API ?
class CagesController < ApplicationController
  before_action :set_cage, only: %i[ show update destroy ]

  # GET /cages
  def index
    @cages = Cage.all

    render json: @cages
  end

  # GET /cages/1
  def show
    render json: @cage
  end

  # POST /cages
  def create
    # TODO: Replace this with an operation
    @cage = Cage.new(cage_params)

    if @cage.save
      render json: @cage, status: :created, location: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cages/1
  def update
    # TODO: Replace this with an operation
    if @cage.update(cage_params)
      render json: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cages/1
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
    params.require(:cage).permit(:number, :vore_id)
  end
end