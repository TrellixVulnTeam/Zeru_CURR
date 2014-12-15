class ReleaseWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    MemoidMailer.notification.deliver
  end
end
