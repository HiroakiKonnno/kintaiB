class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :index]
  before_action :set_one_month, only: :show
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def index
    @users = if params[:search]
    User.paginate(page: params[:page]).where('name LIKE ?',"%#{params[:search]}%")
  else
    User.paginate(page: params[:page])
  end
  end
  
  def new
    @user = User.new
  end
  
  def create
   @user = User.new(user_params)
    if @user.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to root_url
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "ユーザー情報を更新しました。"
    redirect_to @user
  else
    render :edit
  end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
  @user = User.find(params[:id])
  if @user.update_attributes(basic_info_params)
    flash[:success] = "基本情報を更新しました。"
  else
    flash[:danger] = "更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
  end
  redirect_to @user
  end
  
   private
   
   def user_params
      params.require(:user).permit(:name, :email, :belonging, :password, :password_confirmation)
   end
   
   def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
   end

end
   
