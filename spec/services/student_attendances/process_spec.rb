RSpec.describe StudentAttendances::Process do
  subject(:service) { described_class.new(school).call }
  let(:school) { create(:school) }
  let(:expected_school_url_address) do
    "curl #{URI.join(school.url_address, "/api/location/v3/clients?associatedOnly=true")} -H 'Authorization: Basic #{Base64.strict_encode64("#{school.username}:#{school.password}")}'"
  end
  let(:username) { 'Some name' }
  let(:first_seen_at) { DateTime.current.change(usec: 0) }
  let(:location_event) { location_update_event(user_name: username, first_seen_at: first_seen_at) }
  let(:response_double) do
    [
      location_event
    ].to_json
  end
  let(:s3_double) { instance_double('Aws::S3::Resource') }
  let(:bucket_double) { double('Bucket') }
  let(:object_double) { double('Object') }
  let(:zone) { create(:zone, school: school, name: location_event['locationMapHierarchy']) }

  describe '#call' do
    before do
      allow(IO).to receive(:popen)
        .and_return(response_double)
      allow(Aws::S3::Resource).to receive(:new)
        .and_return(s3_double)
      allow(s3_double).to receive(:bucket)
        .and_return(bucket_double)
      allow(bucket_double).to receive(:object)
        .and_return(object_double)
      allow(object_double).to receive(:put)
    end

    describe 'makes request to school server' do
      it 'with valid credentials' do
        service
        expect(IO).to have_received(:popen)
          .with(expected_school_url_address)
      end
    end

    describe 'upload response to AWS S3' do
      let(:expected_bucket) { 'my-bucket-uniq228' }
      it do
        service
        expect(s3_double).to have_received(:bucket)
          .with(expected_bucket)
        expect(bucket_double).to have_received(:object)
          .with(/#{school.name}\/#{school.name}/)
      end
    end

    describe 'creates zone if it does not exist' do
      it do
        expect{ service }.to change{ Zone.count }.from(0).to(1)
      end
    end

    describe 'does not create zone if it exists' do
      it do
        zone
        expect{ service }.to change{ Zone.count }.by(0)
      end
    end

    describe 'creates student if it does not exist' do
      it do
        expect { service }.to change { StudentAttendance.count }.from(0).to(1)
      end
    end

    describe 'does not create student if name is NOT APPLICABLE' do
      let(:username) { 'NOT APPLICABLE' }

      it do
        expect { service }.to change { StudentAttendance.count }.by(0)
      end
    end

    describe 'does not create student if it exists' do
      let(:student_attendance) do
        create(:student_attendance,
               zone: zone,
               first_seen_at: first_seen_at,
               identifier: username)
      end

      it do
        student_attendance
        expect { service }.to change { StudentAttendance.count }.by(0)
      end
    end
  end
end
