class AirportsController < ApplicationController
  # GET /airports
  # GET /airports.json
  def index
    @airports = Airport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @airports }
    end
  end

  # GET /airports/1
  # GET /airports/1.json
  def show
    @airport = Airport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @airport }
    end
  end

  # GET /airports/new
  # GET /airports/new.json
  def new
    @airport = Airport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @airport }
    end
  end

  # GET /airports/1/edit
  def edit
    @airport = Airport.find(params[:id])
  end

  # POST /airports
  # POST /airports.json
  def create
    @airport = Airport.new(params[:airport])

    respond_to do |format|
      if @airport.save
        format.html { redirect_to @airport, notice: 'Airport was successfully created.' }
        format.json { render json: @airport, status: :created, location: @airport }
      else
        format.html { render action: "new" }
        format.json { render json: @airport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /airports/1
  # PUT /airports/1.json
  def update
    @airport = Airport.find(params[:id])

    respond_to do |format|
      if @airport.update_attributes(params[:airport])
        format.html { redirect_to @airport, notice: 'Airport was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @airport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airports/1
  # DELETE /airports/1.json
  def destroy
    @airport = Airport.find(params[:id])
    @airport.destroy

    respond_to do |format|
      format.html { redirect_to airports_url }
      format.json { head :no_content }
    end
  end
end
