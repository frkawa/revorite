class ApplicationController < ActionController::Base
  before_action :set_request_filter
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ページネーションで利用。1スクロール当たり何件表示するか
  PAGENATION_PAGES = 10

  def set_request_filter
    Thread.current[:request] = request
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :description, %i(image)]) #プロフィール編集時(account_update時)にnameとdescriptionとimageというキーのパラメーターを追加で許可する
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
