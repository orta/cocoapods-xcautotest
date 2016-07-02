module Pod
  class Command
    class XCAutotest < Command
      self.summary = 'Short description of cocoapods-xcautotest.'

      self.description = <<-DESC
        Longer description of cocoapods-xcautotest.
      DESC

      self.arguments = 'NAME'
      self.name = 'autotest'

      def initialize(argv)
        @name = argv.shift_argument
        super
      end

      def validate!
        super
        help! 'A Pod name is required.' unless @name
      end

      def run

      end
    end
  end
end
