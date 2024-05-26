<h1 align="center"> Notifications </h1>

Support for email, Microsoft Teams and Slack notifications from CodeBuild/CodePipeline to send event notifications.

* The diagram below presents the architecture created after deploying [notifications](../modules/accelerator/notifications) module.
![Microsoft Teams and Slack Notifications](../docs/pic/codepipeline_events.png)

* `CloudWatch Event rules` watches for a specific type of event from `CodeBuild/CodePipeline`. When a matching event comes in, the rule routes it to one or more targets(`SNS topic`) which trigger the notification lambda function.
* If you define one of the notification methods, you get a notification there.

#### [Previous page](./cicd.md)
