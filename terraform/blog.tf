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

resource "aws_iam_user" "site_travis" {
  name = "site.travis"
}

resource "aws_iam_access_key" "site_travis" {
  user = aws_iam_user.site_travis.name
}

resource "aws_iam_user_policy" "site_travis" {
  name   = "AllowSitePushing"
  user   = aws_iam_user.site_travis.name
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
