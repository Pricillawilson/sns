resource "aws_sns_topic" "cpu_utilization_topic"{
    name = var.topic_name
}

resource "aws_sns_topic_subscription" "mailid"{
    topic_arn = aws_sns_topic.cpu_utilization_topic.arn
    protocol = "email"
    endpoint = "trichetcathrin@gmail.com"

}