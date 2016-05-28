require 'spec_helper'
describe 'opensshmodule' do

  context 'with defaults for all parameters' do
    it { should contain_class('opensshmodule') }
  end
end
