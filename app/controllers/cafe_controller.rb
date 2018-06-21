class CafeController < ApplicationController
  def index
    @Caves = Cafe.all
  end
  
  
  def new
  end
  
  def create
    cafe = Cafe.new
    cafe.title = params[:title]
    cafe.description = params[:description]
    cafe.save
    
    redirect_to "/caves"
  end

  def edit
    @cafe = Cafe.find(params[:id])
  end
  
  def update
    cafe = Cafe.find(params[:id])
    cafe.title = params[:title]
    cafe.description= params[:description]
    cafe.save
    
    redirect_to "/caves"
  end

  def destroy
    cafe = Cafe.find(params[:id])
    cafe.destroy
    
    redirect_to "/caves"
  end
  
  def show
    @cafe = Cafe.find(params[:id])
  end
  
end
