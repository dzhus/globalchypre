resource "aws_s3_bucket" "dzhus-org" {
  bucket = "dzhus-org"

  website {
    index_document = "index.html"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Principal": "*",
            "Effect": "Allow",
            "Action":[
                "s3:GetObject"
            ],
            "Resource":[
                "arn:aws:s3:::dzhus-org/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "blog_travis" {
  name = "blog.travis"
}

resource "aws_iam_access_key" "blog_travis" {
  user = "${aws_iam_user.blog_travis.name}"
}

resource "aws_iam_user_policy" "blog_travis" {
  name = "AllowBlogPushing"
  user = "${aws_iam_user.blog_travis.name}"
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
                "arn:aws:s3:::${aws_s3_bucket.dzhus-org.bucket}/*"
            ]
        }
    ]
}
EOF
}
