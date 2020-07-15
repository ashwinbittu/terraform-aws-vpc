output "aws_vpc_id" {
  value       = aws_vpc.main.id
}

output "aws_subnet_ids" {
  value = "${aws_subnet.main-public.*.id}"
}

output "aws_gw_id" {
  value       = aws_internet_gateway.main-gw.id
}