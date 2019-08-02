###tf-aws-mod-kmskey

* This module will create a KMS key.  
* You can acc[pt the default security policy for the key, or specify a json document with a custom security policy.In most cases the default security policy should be adequate
* You may optionally  create an alias for the KMS key.



##Example usage:
```
provider "aws" {
  region  = "us-west-2"
  profile = "myprofilename"
}

module "this_key" {
  source                  = "../../tf-aws-mod-kmskey"
  description             = "test with default policy"
  deletion_window_in_days = 15
  enable_key_rotation     = true

  tags = {
    "SnowAppCode"     = "1234"
    "SnowAppName"     = "SampleApp"
    "SnowAppSupport"  = "john.doe@example.com"
    "SnowAppSysId"    = "1234"
    "SnowChargeCode"  = "000-000"
    "SnowEnvironment" = "dev"
    "SnowRITM"        = "RITM000000"
  }

  # Set to false if you do not want to create a KMS key alias
  create_alias         = true
  alias                = "chimp"

  # Set to true if you want to use a custom seccurity policy document
  # You must create the document and place it in the folder where you are calling this module from.
  # NOT the module folder.
  create_custom_policy = false
  custom_policy        = "${path.root}/sample.json"
}



output "key_id" {
  value = "${module.this_key.key_id}"
}

output "key_arn" {
  value = "${module.this_key.key_arn}"
}

output "alias_arn" {
  value = "${module.this_key.alias_arn}"
}
```

##Sample Policy Docs
in the subfolder sample_policy_docs are several sample key security policies.  Items that need to be customized for your environment are in all caps (e.g. ACCOUNT_ID) and should be relatively self explanatory. 

You may consider using these as a template in your solution.

```
data "aws_caller_identity" "current" {}

data "template_file" "backup-key" {
  template = "${file(path/to/file/backup-key.json")}"
  vars = {
    ACCOUNT_ID = "${data.aws_caller_identity.current.account_id}"
    FULL_ADMIN_ROLE = "tfsaws_full_admins"
    COMPUTE_ADMIN_ROLE = "tfsaws_computer_admins"

  }
}

resource "local_file" "backup-key" {
    content     = "${data.template_file.backup-key.rendered}"
    filename = "${path.root}/backup-key-policy.json"
}

#then call the module, referenceing the custom file you created above
module "backup-key" {
  ....
  create_custom_policy = true
  custom_policy        = "${path.root}/backup-key-policy.json"
}
```