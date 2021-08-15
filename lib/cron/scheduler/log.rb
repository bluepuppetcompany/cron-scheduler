module Cron
  module Scheduler
    class Log < ::Log
      def tag!(tags)
        tags << :cron
      end
    end
  end
end
