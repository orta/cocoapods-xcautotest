module Pod
  class Command
    class XCAutotest < Command
      self.summary = 'Short description of cocoapods-xcautotest.'

      self.description = <<-DESC
        Longer description of cocoapods-xcautotest.
      DESC

      self.command = 'autotest'

      def run
        # start the websocket server

      end
    end
  end
end
