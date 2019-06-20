module StudentAttendances
  class Process
    def initialize(school)
      @school = school
    end

    def call
      response = IO.popen("curl #{URI.join(school[:url_address], "/api/location/v3/clients?associatedOnly=true")} -H 'Authorization: Basic #{Base64.strict_encode64("#{school[:username]}:#{school[:password]}")}'") { |f| f.gets() }
      results = JSON(response)

      s3 = Aws::S3::Resource.new
      obj = s3.bucket('my-bucket-uniq228').object("#{school.name}/#{school.name}-#{DateTime.current}.json")
      obj.put(body: results.map{|item| JSON.dump(item)}.join("\n"))

      zones = results.map{|a| a["locationMapHierarchy"]}.uniq.sort

      zones.each do |zone|
        Zone.create(name: zone, school: school) unless Zone.exists?(name: zone, school: school)
      end

      students = results.select{ |a| a["notificationType"] == "locationupdate"}.map{|a| {zone: a["locationMapHierarchy"], username: a["username"], first_seen: DateTime.strptime(a["notificationTime"],'%Q') } }

      zones = school.zones.map{ |zone| zone.slice(:id, :name) }

      bulk_insert_array = []
      bulk_update_array = []

      students.each do |student|
        next if student[:username] == 'NOT APPLICABLE'
        zone = zones.select{|zone| zone[:name] == student[:zone]}.first[:id]
        record = StudentAttendance.where(identifier: student[:username], zone_id: zone, first_seen_at: student[:first_seen]).first
        if !record
          bulk_insert_array << StudentAttendance.new(identifier: student[:username], zone_id: zone, first_seen_at: student[:first_seen], last_seen_at: Time.now)
        else
          bulk_update_array << record.id
        end
      end
      StudentAttendance.import bulk_insert_array
      StudentAttendance.where(id: bulk_update_array).update_all(last_seen_at: Time.now)
    end

    private

    attr_reader :school
  end
end
