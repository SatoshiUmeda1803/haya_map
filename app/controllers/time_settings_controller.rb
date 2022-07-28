class TimeSettingsController < ApplicationController
  def edit
    @time_setting = current_user.time_setting
  end

  def update
    @time_setting = current_user.time_setting
    if @time_setting.update(setting_params)
      redirect_to edit_time_setting_path, success: '設定を保存しました'
    else
      flash.now[:danger] = '設定を保存できませんでした'
      render :edit
    end
  end

  private

  def setting_params
    params.require(:time_setting).permit(:randomized, :costom_time)
  end
end
