class LogActividadesChannel < ApplicationCable::Channel
  def subscribed
    stream_from params[:usuario_role] if params[:usuario_role].present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
