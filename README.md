# ops-cloudformation

## Usage
  - If the stack already exists it will update it, otherwise it will create a new one, the default region is ap-southeast-2 if not specified
  ```
    make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json
  ```

  -   (Optional) you can specify the region where you want to create or update the stack  
  ```
    make buildStack STACK_NAME=foo CFN_LOCATION=network/template.yml CFN_PARAMS=network/params.json DEFAULT_REGION=us-west-2
  ```

  - Delete a stack, you can also specify the region
  ```
    make deleteStack STACK_NAME=foo DEFAULT_REGION=us-west-2
  ```

## Network

### Params

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| EnvironmentName |  | `test` | yes |
| VpcCIDR |  | `10.0.0.0/16` | yes |
| AvailabilityZones |  | `ap-southeast-2a,ap-southeast-2b,ap-southeast-2c` | yes |
| PublicSubnetCIDR |  | `10.0.0.0/24,10.0.1.0/24,10.0.2.0/24` | yes |
| AppSubnetCIDR |  | `10.0.10.0/24,10.0.11.0/24,10.0.12.0/24` | yes |
| DataSubnetCIDR |  | `10.0.20.0/24,10.0.21.0/24,10.0.22.0/24` | yes |
| VpcFlowLogRetention |  | 14 | no |
| ThreeTier |  | false | no |
