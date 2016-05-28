require 'spec_helper'
describe 'zookeepermodue' do

  context 'with defaults for all parameters' do
    it { should contain_class('zookeepermodue') }
  end
end
