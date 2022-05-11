output "instance_public_ip" {
    description = "Public IP address of the Nginx server"
    value       = aws_instance.NginxServer.public_ip
}