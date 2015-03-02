class Professional::ProfilesController < ApplicationController
  before_action :authenticate_professional!

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.professional = current_professional
    if @profile.save 
      redirect_to root_path
    else
      render :action=>'new'
    end
  end

  def show
    @profile = current_professional.profile
    # if current_professional && current_professional.profile.id == params[:id]
    #   @professional = current_professional
    #   @profile = Profile.find(params[:id])
    # else
    #   @profile = Profile.find(params[:id])
    #   @professional = Professional.where(:id=>@profile.professional_id)
    #   @student = current_student
    # end
  end

  def edit
    @profile = current_professional.profile
  end

  def update
    @profile = current_professional.profile
    @profile.update(profile_params)
    redirect_to profile_path(@profile)
  end

  def destroy
    @profile = current_professional.profile
    @profile.destroy
    redirect_to '/'
    flash[:notice] = "Your profile has been deleted successfully"
  end

  def profile_params
    params.require(:profile).permit(:name, :image, :info, :company, :full_description, :work_address, 
      :profession_id, :motivation, :suitability, :academic_back, :req_quals, :req_skills, :expectations)
  end
end