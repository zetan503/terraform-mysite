data "aws_caller_identity" "current_caller_arn" {}

output "caller_arn" {
  value = data.aws_caller_identity.current_caller_arn.arn
}
data "aws_caller_identity" "current_aws_caller_identity" {}

output "account_id" {
  value = data.aws_caller_identity.current_aws_caller_identity.account_id
}
