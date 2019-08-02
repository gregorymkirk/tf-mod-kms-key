resource "aws_kms_key" "key_default_policy" {
  count                   = "${var.create_custom_policy ? 0 : 1}"
  description             = "${var.description}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  enable_key_rotation     = "${var.enable_key_rotation}"
  tags                    = "${var.tags}"
}

resource "aws_kms_alias" "default" {
  count         = "${var.create_alias && !var.create_custom_policy ? 1 : 0 }"
  name          = "alias/${var.alias}"
  target_key_id = "${aws_kms_key.key_default_policy.0.id}"
}

# We use template systnes instaead of file, to avoid issue with escaping characters
#the custom policy must be a valid AWS json policy for the key.
data "template_file" "policy_doc" {
  count    = "${var.create_custom_policy ? 1 : 0 }"
  template = "${file("${path.root}/${var.custom_policy}")}"
}

resource "aws_kms_key" "key_custom_policy" {
  count                   = "${var.create_custom_policy ? 1 : 0 }"
  description             = "${var.description}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  enable_key_rotation     = "${var.enable_key_rotation}"
  tags                    = "${var.tags}"
  policy                  = "${data.template_file.policy_doc.rendered}"
}

resource "aws_kms_alias" "custom" {
  count         = "${var.create_alias && var.create_custom_policy ? 1 : 0 }"
  name          = "alias/${var.alias}"
  target_key_id = "${aws_kms_key.key_custom_policy.0.id}"
}
