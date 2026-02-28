variable "buckets" {
  type = map(string)
  description = "A map of S3 bucket keys to bucket names key is the buckekt name with the appended hex value and value is the description"
}
