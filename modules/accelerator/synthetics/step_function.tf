#======================= Step functions for AWS Synthetics Canary =======================#
resource "aws_iam_role" "step_function_role" {
  name = "step-function-${var.repo_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "step_function_policy" {
  name = "step_function_policy_${var.repo_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "lambda:InvokeFunction"
        Effect = "Allow"
        Resource = [
          module.start_canary_lambda.lambda_function_arn,
          module.check_canary_status_lambda.lambda_function_arn,
          module.get_canary_results_lambda.lambda_function_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_function_policy_attachment" {
  policy_arn = aws_iam_policy.step_function_policy.arn
  role       = aws_iam_role.step_function_role.name
}

resource "aws_sfn_state_machine" "state_machine" {
  name     = "CanaryStateMachine_${var.repo_name}"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    "Comment" : "Step Function to run a Synthetics Canary.",
    "StartAt" : "StartCanary",
    "States" : {
      "StartCanary" : {
        "Type" : "Task",
        "Resource" : module.start_canary_lambda.lambda_function_arn,
        "Next" : "WaitXSeconds"
      },
      "WaitXSeconds" : {
        "Type" : "Wait",
        "Seconds" : 30,
        "Next" : "CheckCanaryStatus"
      },
      "CheckCanaryStatus" : {
        "Type" : "Task",
        "Resource" : module.check_canary_status_lambda.lambda_function_arn,
        "Next" : "CanaryCompletedChoice"
      },
      "CanaryCompletedChoice" : {
        "Type" : "Choice",
        "Choices" : [
          {
            "Variable" : "$.completed",
            "BooleanEquals" : true,
            "Next" : "GetCanaryResults"
          },
          {
            "Variable" : "$.completed",
            "BooleanEquals" : false,
            "Next" : "WaitXSeconds"
          }
        ]
      },
      "GetCanaryResults" : {
        "Type" : "Task",
        "Resource" : module.get_canary_results_lambda.lambda_function_arn,
        "End" : true
      }
    }
  })
}
