require 'spec_helper'
describe 'apachemodule' do

  context 'with defaults for all parameters' do
    it { should contain_class('apachemodule') }
  end
end
