# Troubleshooting

General troubleshooting if things don't come up as expected.

1. In the ECS Console, you can look at each service and see its status. If you click on a specific service and go to its `Tasks` tab, you can see if any are running and/or stopped. Click on the task itself, and click the drop down arrow for the containers. There is details section that may provide info (especially in the case of stopped tasks).
2. Check the logs in cloudwatch.
3. SSH in
   1. If one of the instances is public, ssh into that one and run `docker ps`, you can scp your key pair into it and ssh into the private instances from there until you find the docker container you are looking for. Then you can exec in as usual for troublehsooting.
   2. If none of the instances are public, launch an instance of any kind and make sure to put it into the Grey Matter ECS VPC. Then once it launches, you can scp your keypair in and ssh into the ecs instances from there.
