RSpec.describe 'Some test' do
  it 'TEST' do
    expect { create(:school) }.to change { School.count }.by(1)
  end
end
