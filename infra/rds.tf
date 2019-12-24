resource "aws_db_subnet_group" "wp_rds_subnet_group" {
  name = "wp-rds-subnet-group"
  subnet_ids = [aws_subnet.wp_private_subnet_0, aws_subnet.wp_private_subnet_1]
}

resource "aws_db_instance" "wp_rds_instance" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mariadb"
  instance_class = "db.t3.medium"
  multi_az = True
  username = var.rds_user
  psasword = var.rds_pass
  db_subnet_group_name = aws_db_subnet_group.wp_rds_subnet_group.name
}
