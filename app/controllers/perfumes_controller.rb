class PerfumesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :index] # 任意：ログイン必須にする場合

  def index
    # 任意：自分の履歴一覧（マイページで出すなら不要）
    @perfumes = current_user.perfumes.order(created_at: :desc)
  end

  def new
    @perfume = Perfume.new
  end

  def show
    @perfume = Perfume.find(params[:id])
    # 自分のデータのみ見せたいなら:
    # redirect_to root_path, alert: "権限がありません" unless @perfume.user_id == current_user.id
  end

  def create
    @perfume = current_user.perfumes.new(perfume_params)
    if @perfume.save
      flash[:notice] = "診断が完了しました"
      redirect_to perfume_path(@perfume.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def perfume_params
    params.require(:perfume).permit(
      :question1, :question2, :question3, :question4,
      :question5, :question6, :question7, :question8, :question9
    )
  end
end