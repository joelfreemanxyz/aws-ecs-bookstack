

# Task IAM role for ecs
resource "aws_iam_role" "wikijs_ecs_task_role" {
  name               = "wikijs_ecs_task_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# Policy that allows tasks to access s3
resource "aws_iam_policy" "wikijs_ecs_task_policy" {
  name   = "wikijs_ecs_task_role_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::wikijs-storage-bucket/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "wikijs_ecs_task_role_policy_attachment" {
  role       = "${aws_iam_role.wikijs_ecs_task_role.name}"
  policy_arn = "${aws_iam_policy.wikijs_ecs_task_policy.arn}"
}



