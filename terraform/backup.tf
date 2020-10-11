variable "backup_bucket" {
  default = "dzhus-backups"
}

resource "aws_s3_bucket" "backup" {
  bucket = var.backup_bucket

  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "backup" {
  name = "backup"
}

resource "aws_iam_access_key" "backup" {
  user = aws_iam_user.backup.name
}

resource "aws_iam_user_policy" "backup" {
  name   = "AllowPushingBackups"
  user   = aws_iam_user.backup.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.backup.bucket}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.backup.bucket}"
            ]
        }
    ]
}
EOF

}

output "backup_access_key_id" {
  value     = aws_iam_access_key.backup.id
  sensitive = true
}

output "backup_secret_access_key" {
  value     = aws_iam_access_key.backup.secret
  sensitive = true
}

output "backup_bucket_region" {
  value     = aws_s3_bucket.backup.region
  sensitive = true
}
