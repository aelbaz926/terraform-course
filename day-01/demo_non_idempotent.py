import boto3

ec2 = boto3.client("ec2", region_name="us-east-1")

AMI_ID = "ami-0c02fb55956c7d316"   # Example Amazon Linux 2 AMI in us-east-1
INSTANCE_TYPE = "t2.micro"

def create_ec2():
    resp = ec2.run_instances(
        ImageId=AMI_ID,
        InstanceType=INSTANCE_TYPE,
        MinCount=1,
        MaxCount=1,
    )
    inst = resp["Instances"][0]
    print(f"Created: {inst['InstanceId']}  State: {inst['State']['Name']}")

def list_ec2():
    resp = ec2.describe_instances()
    for r in resp["Reservations"]:
        for i in r["Instances"]:
            print(f"{i['InstanceId']}  {i['State']['Name']}")

def main():
    create_ec2()      # Every run makes a new instance
    print("\nAll EC2s:")
    list_ec2()

if __name__ == "__main__":
    main()
