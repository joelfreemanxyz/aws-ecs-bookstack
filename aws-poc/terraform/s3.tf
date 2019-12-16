resource "aws_s3_bucket" "name" {
  bucket = "wikijs-storage-bucket"
  acl = "private"
}
