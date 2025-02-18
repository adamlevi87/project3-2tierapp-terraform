output "jump_servers_sg_id" {
    value = aws_security_group.jump_servers_sg.id
}

output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}

output "db_sg_id" {
    value = aws_security_group.db_sg.id
}

output "websrv_sg_id" {
    value = aws_security_group.websrv_sg.id
}