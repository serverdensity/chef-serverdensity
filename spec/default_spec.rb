describe 'serverdensity::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'should install the rest-client gem' do
    expect(chef_run).to install_chef_gem('rest-client')
  end
end