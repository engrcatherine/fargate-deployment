resource "aws_ecr_repository" "main" {
  name = "${var.main.name}-${var.environment}"
  # Other configurations for the ECR repository...
}


resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.id

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}