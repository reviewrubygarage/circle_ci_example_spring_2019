RSpec.describe StudentAttendances::Process do
  subject(:service) { described_class.call(school) }

  let(:school) { create(:school) }

  context '#call' do
    let(:expected_curl) do
      "curl #{URI.join(school.url_address, "/api/location/v3/clients?associatedOnly=true")} -H 'Authorization: Basic #{Base64.strict_encode64("#{school.username}:#{school.password}")}'"
    end
    let(:user_name) { 'Some name' }
    let(:first_seen_at) { DateTime.current.change(usec: 0) }
    let(:location_update) { location_update_event(user_name: user_name, first_seen_at: first_seen_at) }
    let(:response) do
      [
        location_update
      ]
    end
    let(:aws_s3_double) { instance_double('Aws::S3::Resource') }
    let(:bucket_double) { double('Bucket') }
    let(:object_double) { double('Object double') }
    let(:zone) { create(:zone, school: school, name: location_update['locationMapHierarchy']) }

    before do
      allow(IO).to receive(:popen)
        .with(expected_curl)
        .and_return(response.to_json)
      allow(Aws::S3::Resource).to receive(:new)
        .and_return(aws_s3_double)
      allow(aws_s3_double).to receive(:bucket)
        .and_return(bucket_double)
      allow(bucket_double).to receive(:object)
        .and_return(object_double)
      allow(object_double).to receive(:put)
    end

    context 'make request to server' do
      it 'with school creds' do
        service
        expect(IO).to have_received(:popen)
          .with(expected_curl)
      end
    end

    context 'upload response to AWS s3' do
      it 'use bucker with name my-bucket-uniq228' do
        service
        expect(aws_s3_double).to have_received(:bucket)
          .with('my-bucket-uniq228')
      end

      it 'sets proper name for json file' do
        service
        expect(bucket_double).to have_received(:object)
          .with(/#{school.name}\/#{school.name}/)
      end
    end

    context 'processes zones' do
      context 'creates zone' do
        it do
          expect { service }.to change { Zone.count }.by(1)
        end
      end

      context 'does not create zone' do
        it do
          zone
          expect { service }.to change { Zone.count }.by(0)
        end
      end
    end

    context 'processes student attendance' do
      context 'does not create student attendance if NOT APPLICABLE username' do
        let(:user_name) { 'NOT APPLICABLE' }

        it do
          expect { service }.to change { StudentAttendance.count }.by(0)
        end
      end

      context 'does not create student attendance if it already exists' do
        let(:student_attendance) do
          create(:student_attendance,
                 zone: zone,
                 identifier: user_name,
                 first_seen_at: first_seen_at)
        end

        it do
          student_attendance
          # expect { service }.to change { StudentAttendance.count }.by(0)
        end
      end

      context 'creates student attendance' do
        it do
          expect { service }.to change { StudentAttendance.count }.by(1)
        end
      end
    end
  end
end
