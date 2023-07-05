data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.atlantis_role_arn]
    }
  }
}
resource "aws_iam_role" "read_only_access" {
  name = "Read-Only-Access-For-Custodian-${var.region}"
  description = "Role to use if you activate EPAM Custodian to test AWS resources"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "read_only_policy" {
  role       = aws_iam_role.read_only_access.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_ssm_parameter" "role_for_custodian" {
  description = "This role arn atlantis will use during EPAM Custodian check"
  name  = "/custodian/role/arn"
  type  = "String"
  value = aws_iam_role.read_only_access.arn
  depends_on = [aws_iam_role.read_only_access]
}