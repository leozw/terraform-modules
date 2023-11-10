locals {

prefix_access_logs = "alb-logs"

policy_bucket =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${module.s3-access-logs.bucket-name}/${local.prefix_access_logs}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    }
  ]
}
EOF

}