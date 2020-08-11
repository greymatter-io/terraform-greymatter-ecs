resource "aws_vpc_peering_connection" "vpc_peer" {
  count         = "${var.peering_vpc_id != "" ? 1 : 0 }"
  peer_owner_id = "${var.peering_account_id}"
  peer_vpc_id   = "${var.peering_vpc_id}"
  vpc_id        = "${aws_vpc.platform.id}"

  tags = {
    Name = "OpenShift VPC Peer"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
