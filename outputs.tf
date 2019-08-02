output "key_id" {
  value = "${ join("","${aws_kms_key.key_custom_policy.*.id}","${aws_kms_key.key_default_policy.*.id}" )}"
}

output "key_arn" {
  value = "${ join("","${aws_kms_key.key_custom_policy.*.arn}","${aws_kms_key.key_default_policy.*.arn}" )}"
}

output "alias_arn" {
  value = "${ join("","${aws_kms_alias.default.*.arn}","${aws_kms_alias.custom.*.arn}")}"
}
