module Cron
  module Scheduler
    def self.included(cls)
      cls.class_exec do
        include Actor
        include Log::Dependency

        handle :start do
          logger.trace(tag: :scheduler) { "Starting scheduler... (#{Process.pid})" }

          logger.trace(tag: :scheduler) { "Started scheduler. (#{Process.pid})" }
        end

        handle :dispatch do |dispatch|
          logger.debug(tag: :scheduler) { "Dispatching tasks... (Timestamp: #{dispatch.timestamp})"}

          logger.debug(tag: :scheduler) { "Dispatch tasks. (Timestamp: #{dispatch.timestamp})"}
        end
      end
    end

    Dispatch = Struct.new(:timestamp) do
      include Actor::Messaging::Message
    end
  end
end
