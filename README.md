# Serverless Template

This is a template for simple serverless lambda functions. It uses Terraform to manage the infrastructure and AWS Lambda to run the code.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Node.js](https://nodejs.org/en/download/)
- [AWS Account](https://aws.amazon.com/)

## Setup

1. Install the prerequisites
2. Run `npm install` in `functions` to install the dependencies
3. Run `npm run build` in `functions` to build the code
4. Run `terraform init` in `cloud` to initialize Terraform
5. Run `terraform apply` in `cloud` to create the infrastructure

The `terraform apply` command will output the Lambda Function URLs. You can use this URL to make requests to the lambda function.

## Development

### Creating a new function

1. Simply add new lambda functions in the `functions/src` directory and run `npm run build` to build the code.
2. In the `cloud/api.tf` file, add a new function in the `locals.functions` block.
3. Then run `terraform apply` to deploy the new function.

### Updating a function

1. Update the lambda function in the `functions/src` directory and run `npm run build` to build the code.
2. Run `terraform apply` to update the function.

### Deleting a function

1. In the `cloud/api.tf` file, remove the function from the `locals.functions` block.
2. Run `terraform apply` to delete the function.

### Modifying the function configuration

In the `cloud/api.tf` file, you can modify the function configuration in the `locals.functions` block. If you want to change the function name, memory size, timeout, or environment variables, you can do so in this block. For other configurations, you can modify the `aws_lambda_function` resource.

## Terraform Customization

In the `cloud` directory, you can modify the `main.tf` file to customize the infrastructure configuration. You can update the project name, region, and other configurations in this file.

### Production and Development Environments

You can use Terraform workspaces to manage different environments. For example, you can create a `prod` workspace and a `dev` workspace. You can then use the `terraform workspace select` command to switch between the environments. The AWS resources will be tagged and named based on the workspace name.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
