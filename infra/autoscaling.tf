resource "aws_appautoscaling_target" "app_ecs_autoscaling_target" {
  service_namespace = "ecs"
  resource_id = "service/${aws_ecs_cluster.app_ecs_cluster.name}/${aws_ecs_service.app_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = 4
  max_capacity = 8
}

resource "aws_appautoscaling_policy" "app_ecs_autoscaling_scale_up" {
  name = "app-scale-up"
  service_namespace = "ecs"
  resource_id = "service/${aws_ecs_cluster.app_ecs_cluster.name}/${aws_ecs_service.app_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type = "changeInCapacity"
    cooldown = "60"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cloudwatch_scale_up_alarm" {
  name = "app-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "80"

  dimensions = {
      ClusterName = aws_ecs_cluster.app_ecs_cluster.name
      ServiceName = aws_ecs_service.app_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_ecs_autoscaling_scale_up.arn]
}

resource "aws_appautoscaling_policy" "app_ecs_autoscaling_scale_down" {
  name = "app-scale-down"
  service_namespace = "ecs"
  resource_id = "service/${aws_ecs_cluster.app_ecs_cluster.name}/${aws_ecs_service.app_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type = "changeInCapacity"
    cooldown = "60"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cloudwatch_scale_down_alarm" {
  alarm_name = "app-scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "10"

  dimensions = {
      ClusterName = aws_ecs_cluster.app_ecs_cluster.name
      ServiceName = aws_ecs_service.app_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_ecs_autoscaling_scale_up.arn]
}
