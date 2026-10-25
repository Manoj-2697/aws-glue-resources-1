# Repository: aws-glue-resources-1
# File: main.tf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Job 1: Incompatible Legacy Glue 3.0 Job (Has issues)
resource "aws_glue_job" "legacy_telemetry_processor" {
  name              = "legacy-telemetry-processor"
  role_arn          = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"
  glue_version      = "3.0"
  worker_type       = "Standard"
  number_of_workers = 4
  timeout           = 60

  command {
    name            = "glueetl"
    script_location = "s3://company-glue-scripts/telemetry_etl.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"              = "python"
    "--additional-python-modules" = "pandas==2.2.2,scikit-learn>=1.4.0"
  }
}

# Job 2: Clean Modern Glue 5.0 Job (No issues)
resource "aws_glue_job" "customer_events_clean" {
  name              = "customer-events-clean"
  role_arn          = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 4
  timeout           = 30

  command {
    name            = "glueetl"
    script_location = "s3://company-glue-scripts/customer_events.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"              = "python"
    "--additional-python-modules" = "pydantic>=2.5.0,fastparquet>=2024.2.0"
  }
}
