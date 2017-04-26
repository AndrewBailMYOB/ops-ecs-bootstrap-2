#ops-cloudformation

##Usage
    `make create`
    `make delete`

##Network

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
