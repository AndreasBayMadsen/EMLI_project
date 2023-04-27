from influxdb import InfluxDBClient

def main():
    # Establish client
    client = InfluxDBClient(username="ros2", password="ros2_passwd", database="cpu_temp")

    # Create data
    data = [
        {
            "measurement": "something",
            "tags": {
                "fruit": "banana",
                "animal": "dog"
            },
            "time": "2009-11-10T23:00:00Z",
            "fields": {
                "Float_value": 0.64,
                "Int_value": 3,
                "String_value": "Text",
                "Bool_value": True
            }
        }
    ]

    # Write data
    client.write_points(data)

if __name__ == "__main__":
    main()