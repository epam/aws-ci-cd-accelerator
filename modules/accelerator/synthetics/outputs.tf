output "statemachine_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.arn
}
