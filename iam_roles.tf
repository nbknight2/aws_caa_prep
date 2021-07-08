resource "aws_iam_role_policy" "iam_read_only_policy" {
  name = "aws-caa-readonly"
  role = aws_iam_role.iam_read_only_role.id
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "iam:GenerateCredentialReport",
              "iam:GenerateServiceLastAccessedDetails",
              "iam:Get*",
              "iam:List*",
              "iam:SimulateCustomPolicy",
              "iam:SimulatePrincipalPolicy"
          ],
          "Resource": "*"
      }
  ]
}
)
}

resource "aws_iam_role" "iam_read_only_role" {
  name = "DemoRoleForEC2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
