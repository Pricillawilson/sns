data "template_file" "cloudformation_sns_stack"{
    template = file("${path.module}/templates/alarm-sns-stack.json.tpl")

    vars = {
      display_name = var.display_name
      subscriptions = join(
          ",",
          formatlist(
              "{ \"Endpoint\": \"%s\", \"Protocol\": \"%s\" }",
              var.email_subscription,
              var.protocol,
          ),
      )
    }
}

resource "aws_cloudformation_stack" "cpu_utilization_topic"{
    for_each = toset(var.topics)
    name = "${each.key}-topic"
    template_body = data.template_file.cloudformation_sns_stack.rendered
}

module "single_subscription"{
    source = "./sns-module"
    for_each = toset(var.topics)
    topic_name = each.key
}





# output "topic_arn"{
#     value = { for i,j in aws_sns_topic.cpu_utilization_topic: i => j.arn }
        
# }
# aws_sns_topic.cpu_utilization_topic[each.key].arn
# module "sns" {
#     source = "./sns-module"
#     for_each = toset(var.topics)
#     topic_name = each.key
# }

# output "topic-arn"{
#     value = module.sns["consumer"]
# }


# #######################
# module "cloudwatch_alarms_services"{
#     source = "../../modules/module-aws-cloudwatch-alarms"

#     for_each = local.appl_envvars_map
#     alarm_name_list = "${var}"
# }
#########################

