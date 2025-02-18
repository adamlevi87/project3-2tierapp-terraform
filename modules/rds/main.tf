# Create an RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "my-${var.project_name}_rds_subnet_group"
    description = "an RDS Subnet Group"
    subnet_ids = [ var.private_sub_3_az1_id, var.private_sub_4_az2_id ]
    tags = {
      Name = "${var.project_name}-rds-subnet-group"
      Project = var.project_name
    }
}

# Create an RDS (Relational Database Service)
resource "aws_db_instance" "rds_mysql_server" {
    identifier = "my-${var.project_name}-db"
    engine = "mysql"
    engine_version = "5.7"
    username = var.db_username
    password = var.db_password
    db_name = var.db_name
    instance_class = "db.t3.micro"
    storage_type = "gp2"
    allocated_storage = 20
    storage_encrypted = false
    multi_az = true
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    publicly_accessible = false
    vpc_security_group_ids = [ var.db_sg_id ]
    backup_retention_period = 0 # No backups
    skip_final_snapshot = true # Don't Backup on resource deletion

    tags = {
      Name = "${var.project_name}-db"
      Project = var.project_name
    }
}

resource "null_resource" "stop_rds_instance" {
  count = var.rds_running_status == "stop" ? 1 : 0  # Only stop if rds_creation_status is "stop"
  provisioner "local-exec" {
    command = "aws rds stop-db-instance --db-instance-identifier ${aws_db_instance.rds_mysql_server.identifier}"
  }

  depends_on = [aws_db_instance.rds_mysql_server]
}

resource "null_resource" "start_rds_instance" {
  count = var.rds_running_status == "start" ? 1 : 0  # Only stop if rds_creation_status is "stop"
  provisioner "local-exec" {
    command = "aws rds start-db-instance --db-instance-identifier ${aws_db_instance.rds_mysql_server.identifier}"
  }

  depends_on = [aws_db_instance.rds_mysql_server]
}
