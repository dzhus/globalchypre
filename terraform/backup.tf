variable "backup_bucket" {
  default = "dzhus-backups"
}

resource "aws_s3_bucket" "backup" {
  bucket = var.backup_bucket

  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "backup_tundra" {
  name = "backup.tundra"
}

resource "aws_iam_access_key" "backup_tundra" {
  user = aws_iam_user.backup_tundra.name
}

resource "aws_iam_user_policy" "backup_tundra" {
  name   = "AllowPushingBackups"
  user   = aws_iam_user.backup_tundra.name
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
  value     = aws_iam_access_key.backup_tundra.id
  sensitive = true
}

output "backup_secret_access_key" {
  value     = aws_iam_access_key.backup_tundra.secret
  sensitive = true
}

output "backup_bucket_region" {
  value     = aws_s3_bucket.backup.region
  sensitive = true
}
