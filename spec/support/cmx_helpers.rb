module CmxHelpers
  def location_update_event(**options)
    {
      'notificationType' => 'locationupdate',
      'subscriptionName' => 'CMX_Api_Server_Notification_1',
      'eventId' => 285726681,
      'locationMapHierarchy' => 'DevNetCampus>DevNetBuilding>DevNetZone',
      'locationCoordinate' => {
          'x' => 197.83774,
          'y' => 47.855194,
          'z' => 0,
          'unit' => 'FEET'
      },
      'geoCoordinate' => {
          'latitude' => 41.35574339438224,
          'longitude' => 2.134619180290046,
          'unit' => 'DEGREES'
      },
      'confidenceFactor' => 56,
      'apMacAddress' => '00:2b:01:00:09:00',
      'associated' => true,
      'username' => options[:user_name] || 'NOT APPLICABLE',
      'ipAddress' => [
          '10.10.20.216'
      ],
      'ssid' => 'test',
      'band' => 'IEEE_802_11_B',
      'floorId' => 723413320329068700,
      'floorRefId' => '723413320329068670',
      'entity' => 'WIRELESS_CLIENTS',
      'deviceId' => '00:00:2a:01:00:39',
      'lastSeen' => '2019-05-31T04:56:39.571+0100',
      'rawLocation' => {
          'rawX' => -999,
          'rawY' => -999,
          'unit' => 'FEET'
      },
      'tagVendorData' => nil,
      'locComputeType' => 'RSSI',
      'manufacturer' => 'TRW - SEDD/INP',
      'maxDetectedRssi' => {
          'apMacAddress' => '00:2b:01:00:0b:00',
          'band' => 'IEEE_802_11_B',
          'slot' => 0,
          'rssi' => -32,
          'antennaIndex' => 0,
          'lastHeardInSeconds' => 2
      },
      'timestamp' => 1559274999571,
      'sourceNotification' => '127.0.0.1',
      'sourceNotificationKey' => '127.0.0.1,3',
      'notificationTime' => (options[:first_seet_at] || DateTime.now).strftime("%Q")
    }
  end
end
