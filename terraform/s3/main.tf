resource "aws_s3_bucket_website_configuration" "main_bucket_web_config" {
  bucket = aws_s3_bucket.main.bucket

  index_document {
    suffix = "index.html"
  }


}
resource "aws_s3_bucket" "main" {
  bucket = "cloudess1-bucket"
  tags = {
    Name = "My Bucket"
    Environment = "Development"
  }

}
resource "aws_s3_bucket_acl" "my_main_bucket_acl" {
  bucket = aws_s3_bucket.main.id
  acl    = "public-read"
  
}
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "index.html"
  etag = filemd5("index.html")
  content_type = "text/html"
  
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.access_bucket_object.json
}
data "aws_iam_policy_document" "access_bucket_object" {
  statement {
    sid = "public_access_bucket"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.main.bucket}/*"]
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}