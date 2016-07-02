require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Xcautotest do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ xcautotest }).should.be.instance_of Command::Xcautotest
      end
    end
  end
end

