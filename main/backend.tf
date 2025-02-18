terraform {
    backend "s3" {
      bucket = "tfstate-adam-101"
      key = "backend/2tierapp.tfstate"
      region = "us-east-1"
      dynamodb_table = "dynamo-demo"
    }
}