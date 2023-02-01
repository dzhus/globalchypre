variable "new_site" {
  default = "djouce.eu"
}

variable "site" {
  default = "dzhus.org"
}

resource "aws_s3_bucket" "new_site" {
  bucket = var.new_site
  website {
    redirect_all_requests_to = aws_s3_bucket.site.bucket
  }
}

resource "aws_s3_bucket" "site" {
  bucket = var.site

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Principal": "*",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.site}/*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_user" "site_ci" {
  name = "site.ci"
}

resource "aws_iam_access_key" "site_ci" {
  user = aws_iam_user.site_ci.name
}

output "site_ci_access_key_id" {
  value     = aws_iam_access_key.site_ci.id
  sensitive = true
}

output "site_ci_secret_access_key" {
  value     = aws_iam_access_key.site_ci.secret
  sensitive = true
}

resource "aws_iam_user_policy" "site_ci" {
  name   = "AllowSitePushing"
  user   = aws_iam_user.site_ci.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.site.bucket}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.site.bucket}"
            ]
        }
    ]
}
EOF

}
