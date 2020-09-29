# edge lb dns name - for ingress to mesh
output "edge_dns" {
  value = aws_lb.edge.dns_name
}