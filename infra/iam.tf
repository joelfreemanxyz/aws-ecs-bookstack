# pull ecs_task_execution policy from AWS
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# create task execution role, and assume the role policy we pulled above
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution_role.json}"
}

# attach iam policy to role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       =  aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  depends_on = [aws_iam_role.ecs_task_execution_role, data.aws_iam_policy_document.ecs_task_execution_role]
} 
