data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_user" "user" {
  name = var.key_name
}

resource "aws_iam_access_key" "user_access_key" {
  count = var.pgp_key == "" ? 1 : 0
  user  = aws_iam_user.user.name
}

resource "aws_iam_access_key" "user_access_key_with_pgp_key" {
  count   = var.pgp_key != "" ? 1 : 0
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
}


resource "aws_iam_user_policy" "user_policy" {
  name       = "${var.key_name}-policy"
  user       = aws_iam_user.user.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3"
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        "Sid" : "AllowSQS"
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
        ],
        "Resource" : [
          "arn:aws:sqs:${var.aws_region}:${local.account_id}:${var.sqs_name}",
        ]
      }
    ]
  })
}
