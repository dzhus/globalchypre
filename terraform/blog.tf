variable "new_site" {
  default = "djouce.eu"
}

variable "site" {
  default = "dzhus.org"
}

resource "aws_s3_bucket" "new_site" {
  bucket = var.new_site
}

resource "aws_s3_bucket_website_configuration" "new_site" {
  bucket = aws_s3_bucket.new_site.id
  redirect_all_requests_to {
    host_name = aws_s3_bucket.site.bucket
  }
}

import {
  to = aws_s3_bucket_website_configuration.new_site
  id = "djouce.eu"
}

resource "aws_s3_bucket" "site" {
  bucket = var.site

}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
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

import {
  to = aws_s3_bucket_website_configuration.site
  id = "dzhus.org"
}

import {
  to = aws_s3_bucket_policy.site
  id = "dzhus.org"
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
