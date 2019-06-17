RSpec.describe 'Some test' do
  it 'creates school' do
    expect{ create(:school) }.to change{ School.count }.by(1)
    expect{ create(:school) }.to change{ School.count }.by(1)
  end
end
